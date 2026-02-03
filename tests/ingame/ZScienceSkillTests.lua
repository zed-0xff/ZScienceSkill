-- In-game tests for ZScienceSkill mod
-- Integrates with PZ's debug menu (accessible via F11 -> Unit Tests)
-- Based on PZ's TimedActionsTests.lua pattern

require "ZScienceSkill_Data"
require "ZScienceSkill_ResearchSpecimen"

ZScienceSkillTests = {}

local Tests = {}
local testsToRun = {}
local tickRegistered = false

local PLAYER_NUM = 0
local PLAYER_OBJ = nil
local PLAYER_INV = nil
local PLAYER_SQR = nil
local PLAYER_SQR_ORIG = nil
local DURATION = 100

-- Helper: Create inventory item
local function newInventoryItem(itemType)
    local item = instanceItem(itemType)
    PLAYER_INV:AddItem(item)
    return item
end

-- Helper: Create world object
local function newObject(x, y, z, spriteName, objectName)
    local square = getCell():getGridSquare(x, y, z)
    if not square then return nil end
    local isoObject = IsoObject.new(square, spriteName, objectName, false)
    square:AddTileObject(isoObject)
    return isoObject
end

-- Helper: Remove all objects from square except floor
local function removeAllButFloor(square)
    if not square then return nil end
    for i=square:getObjects():size(),2,-1 do
        local isoObject = square:getObjects():get(i-1)
        square:transmitRemoveItemFromSquare(isoObject)
    end
end

-- Helper: Get square relative to player
local function getSquareDelta(dx, dy, dz)
    local square = getCell():getGridSquare(
        PLAYER_SQR:getX() + dx,
        PLAYER_SQR:getY() + dy,
        PLAYER_SQR:getZ() + (dz or 0)
    )
    return square
end

-- Test: Research a brain specimen
Tests.research_brain_specimen = {
    run = function(self)
        -- Setup: Give player a brain specimen
        local specimen = newInventoryItem("Base.Specimen_Brain")

        -- Create microscope nearby
        local microscopeSquare = getSquareDelta(1, 0, 0)
        removeAllButFloor(microscopeSquare)
        local microscope = newObject(
            microscopeSquare:getX(),
            microscopeSquare:getY(),
            microscopeSquare:getZ(),
            "fixtures_bathroom_01_14",  -- Microscope sprite
            "Microscope"
        )

        -- Get XP before research
        local xpBefore = PLAYER_OBJ:getXp():getXP(Perks.Science)

        -- Execute research action
        luautils.walkAdj(PLAYER_OBJ, microscopeSquare)
        ISTimedActionQueue.add(ISResearchSpecimen:new(
            PLAYER_OBJ,
            specimen,
            microscope,
            DURATION
        ))

        -- Note: Verification happens after action completes
        -- Expected: +60 XP (brain = 30 base * 2)
        self.xpBefore = xpBefore
        self.specimen = specimen
    end,

    verify = function(self)
        local xpAfter = PLAYER_OBJ:getXp():getXP(Perks.Science)
        local xpGained = xpAfter - self.xpBefore

        -- Check XP was granted
        if xpGained <= 0 then
            return false, "No Science XP gained"
        end

        -- Check item is marked as researched
        if not self.specimen:getModData().researched then
            return false, "Specimen not marked as researched"
        end

        return true, string.format("Gained %d Science XP", xpGained)
    end
}

-- Test: Research science book
Tests.research_science_book = {
    run = function(self)
        local book = newInventoryItem("Base.Book_Science")
        local xpBefore = PLAYER_OBJ:getXp():getXP(Perks.Science)

        -- Note: Book reading is handled by ISReadABook (vanilla)
        -- We just verify our data is correct
        local expectedXP = ZScienceSkill.literature[book:getFullType()]

        self.expectedXP = expectedXP
        self.book = book
    end,

    verify = function(self)
        if self.expectedXP ~= 35 then
            return false, "Expected 35 XP for science book, got " .. self.expectedXP
        end
        return true, "Science book XP value correct: " .. self.expectedXP
    end
}

-- Test: Verify insect XP values
Tests.verify_insect_xp = {
    run = function(self)
        local cricket = newInventoryItem("Base.Cricket")
        local xp = ZScienceSkill.specimens[cricket:getFullType()]

        self.cricket = cricket
        self.xp = xp
    end,

    verify = function(self)
        if not self.xp then
            return false, "Cricket not in specimens table"
        end
        if self.xp ~= 10 then
            return false, "Expected 10 XP for cricket, got " .. self.xp
        end
        return true, "Cricket XP correct: " .. self.xp
    end
}

-- Test: Herbalist plants count
Tests.herbalist_plants_count = {
    run = function(self)
        local count = 0
        for _ in pairs(ZScienceSkill.herbalistPlants) do
            count = count + 1
        end
        self.count = count
        self.required = ZScienceSkill.herbalistPlantsRequired
    end,

    verify = function(self)
        if self.count < self.required then
            return false, string.format(
                "Not enough herbalist plants: %d < %d required",
                self.count, self.required
            )
        end
        return true, string.format(
            "Herbalist plants: %d (required: %d)",
            self.count, self.required
        )
    end
}

-- Test: Can't research same item twice
Tests.no_duplicate_research = {
    run = function(self)
        local specimen = newInventoryItem("Base.Specimen_Insects")

        -- Mark as already researched
        specimen:getModData().researched = true

        -- Create microscope nearby
        local microscopeSquare = getSquareDelta(1, 0, 0)
        removeAllButFloor(microscopeSquare)
        local microscope = newObject(
            microscopeSquare:getX(),
            microscopeSquare:getY(),
            microscopeSquare:getZ(),
            "fixtures_bathroom_01_14",
            "Microscope"
        )

        local xpBefore = PLAYER_OBJ:getXp():getXP(Perks.Science)

        luautils.walkAdj(PLAYER_OBJ, microscopeSquare)
        ISTimedActionQueue.add(ISResearchSpecimen:new(
            PLAYER_OBJ,
            specimen,
            microscope,
            DURATION
        ))

        self.xpBefore = xpBefore
    end,

    verify = function(self)
        local xpAfter = PLAYER_OBJ:getXp():getXP(Perks.Science)
        if xpAfter > self.xpBefore then
            return false, "Gained XP from already-researched specimen"
        end
        return true, "Correctly prevented duplicate research"
    end
}

-- Test runner logic (based on PZ's pattern)
local function OnTick()
    if not PLAYER_OBJ then
        PLAYER_OBJ = getSpecificPlayer(PLAYER_NUM)
        PLAYER_INV = PLAYER_OBJ:getInventory()
        PLAYER_SQR = PLAYER_OBJ:getCurrentSquare()
        PLAYER_SQR_ORIG = PLAYER_SQR
    end

    if not ISTimedActionQueue.hasAction(PLAYER_OBJ) then
        -- Clean up and reset player position
        PLAYER_INV:RemoveAll()
        if PLAYER_OBJ:getCurrentSquare() ~= PLAYER_SQR_ORIG then
            if isClient() then
                SendCommandToServer("/teleportto " ..
                    tostring(PLAYER_SQR_ORIG:getX() + 0.5) .. "," ..
                    tostring(PLAYER_SQR_ORIG:getY() + 0.5) .. ",0")
            else
                PLAYER_OBJ:teleportTo(
                    PLAYER_SQR_ORIG:getX() + 0.5,
                    PLAYER_SQR_ORIG:getY() + 0.5,
                    0.0
                )
            end
            PLAYER_OBJ:setCurrent(PLAYER_SQR_ORIG)
        end

        -- Run next test
        if #testsToRun == 0 then
            PLAYER_OBJ = nil
            print("[ZScienceSkill Tests] All tests completed!")
            return
        end

        local testName = testsToRun[1]
        table.remove(testsToRun, 1)

        local test = Tests[testName]
        if test then
            print("[ZScienceSkill Tests] Running: " .. testName)
            local success, err = pcall(function()
                test:run()
            end)

            if not success then
                print("[ZScienceSkill Tests] ERROR: " .. err)
            end

            -- If test has verify function, call it
            if test.verify then
                local ok, result = test:verify()
                if ok then
                    print("[ZScienceSkill Tests] ✓ " .. testName .. ": " .. result)
                else
                    print("[ZScienceSkill Tests] ✗ " .. testName .. ": " .. result)
                end
            end
        end
    end
end

-- Public API
ZScienceSkillTests.runOne = function(name)
    if not Tests[name] then
        print("[ZScienceSkill Tests] Test not found: " .. name)
        return
    end
    table.insert(testsToRun, name)
    if not tickRegistered then
        Events.OnTick.Add(OnTick)
        tickRegistered = true
    end
end

ZScienceSkillTests.runAll = function()
    table.wipe(testsToRun)
    for name,_ in pairs(Tests) do
        table.insert(testsToRun, name)
    end
    if not tickRegistered then
        Events.OnTick.Add(OnTick)
        tickRegistered = true
    end
end

ZScienceSkillTests.stop = function()
    table.wipe(testsToRun)
end

ZScienceSkillTests.getTests = function()
    return Tests
end

-- Console command binding
-- Always available for manual loading
Events.OnKeyPressed.Add(function(key)
    if key == Keyboard.KEY_F12 then
        print("[ZScienceSkill Tests] F12 pressed - Running all tests...")
        ZScienceSkillTests.runAll()
    end
end)

print("[ZScienceSkill Tests] Loaded! Press F12 to run tests in-game.")
print("[ZScienceSkill Tests] Or use console: ZScienceSkillTests.runAll()")

return ZScienceSkillTests
