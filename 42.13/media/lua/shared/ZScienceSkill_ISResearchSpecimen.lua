require "TimedActions/ISBaseTimedAction"
require "ZScienceSkill/Data"

ISResearchSpecimen = ISBaseTimedAction:derive("ISResearchSpecimen")

local SEARCH_RADIUS = 1

-- Check if object is a microscope
local function isMicroscope(obj)
    return obj and obj.getProperties and obj:getProperties():get("CustomName") == "Microscope"
end

-- Find a microscope within radius of player
local function findNearbyMicroscope(character)
    local sq = character:getSquare()
    if not sq then return nil end
    
    local sx, sy, sz = sq:getX(), sq:getY(), sq:getZ()
    
    for x = sx - SEARCH_RADIUS, sx + SEARCH_RADIUS do
        for y = sy - SEARCH_RADIUS, sy + SEARCH_RADIUS do
            local checkSq = getCell():getGridSquare(x, y, sz)
            if checkSq then
                for i = 0, checkSq:getObjects():size() - 1 do
                    local obj = checkSq:getObjects():get(i)
                    if isMicroscope(obj) then
                        return obj
                    end
                end
            end
        end
    end
    return nil
end

function ISResearchSpecimen:isValid()
    -- see ISEatFoodAction:isValid()
    if isClient() and self.item then
        if not self.character:getInventory():containsID(self.item:getID()) then
            return false
        end
    else
        if not self.character:getInventory():contains(self.item) then
            return false
        end
    end
    if ISResearchSpecimen.isResearched(self.character, self.item) then
        return false
    end
    if not findNearbyMicroscope(self.character) then
        HaloTextHelper.addBadText(self.character, getText("Tooltip_NeedMicroscope"))
        return false
    end
    if self.character:tooDarkToRead() then
        HaloTextHelper.addBadText(self.character, getText("ContextMenu_TooDark"))
        return false
    end
    return true
end

function ISResearchSpecimen:isUsingTimeout()
    return false
end

function ISResearchSpecimen:start()
    if isClient() and self.item then
        self.item = self.character:getInventory():getItemById(self.item:getID())
    end
    
    self.item:setJobType(getText("ContextMenu_ResearchSpecimen"))
    self.item:setJobDelta(0.0)
    self:setActionAnim(CharacterActionAnims.Craft)
    self:setOverrideHandModels(nil, self.item)
    self.character:setReading(true)
    self.character:reportEvent("EventRead")
end

function ISResearchSpecimen:update()
    self.item:setJobDelta(self:getJobDelta())
end

function ISResearchSpecimen:stop()
    self.character:setReading(false)
    self.item:setJobDelta(0.0)
    ISBaseTimedAction.stop(self)
end

local function addXpFromTable(character, tbl, key)
    if type(tbl) ~= "table" then
        print("[?] ZScienceSkill: table expected for XP data, got type=" .. type(tbl) .. ", tbl=" .. tostring(tbl) .. ", key=" .. tostring(key))
        return false
    end

    local val = tbl[key]
    if not val then
        print("[?] ZScienceSkill: no XP data for key=" .. tostring(key))
        return false
    end

    if type(val) == "number" then
        addXp(character, Perks.Science, val)
        return true
    end
    if type(val) == "table" then
        for perk, xp in pairs(val) do -- 'perk' can be either string (perk name) or the Perk object itself
            if perk ~= "key" then  -- skip the 'key' field, it's not a perk
                if type(perk) == "string" then
                    perk = Perks[perk]
                end
                if perk and type(xp) == "number" then
                    addXp(character, perk, xp)
                end
            end
        end
        return true
    end

    print("[?] ZScienceSkill: invalid XP data for specimen: type=" .. type(val) .. ", value=" .. tostring(val) .. ", key=" .. tostring(key))
    return false
end

-- Get the research key for a specimen (uses 'key' field if present, otherwise fullType)
local function getSpecimenResearchKey(fullType)
    local config = ZScienceSkill.Data.specimens[fullType]
    if type(config) == "table" and config.key then
        return config.key
    end
    return fullType
end

-- Called by Java networking on server in MP to apply action effects
-- This is where XP and ModData changes should happen for proper MP sync
function ISResearchSpecimen:complete()
    local fullType = self.item:getFullType()
    local fluidType = ZScienceSkill.getFluidType(self.item)
    local researchKey
    local isFluid = false
    
    -- Check if this is a fluid research
    if fluidType and ZScienceSkill.Data.fluids and ZScienceSkill.Data.fluids[fluidType] then
        isFluid = true
        researchKey = "Fluid:" .. fluidType
        -- Grant XP for each perk defined for this fluid
        addXpFromTable(self.character, ZScienceSkill.Data.fluids, fluidType)
    end
    
    -- Regular specimen
    if not isFluid then
        researchKey = getSpecimenResearchKey(fullType)
        addXpFromTable(self.character, ZScienceSkill.Data.specimens, fullType)
    end
    
    -- Update ModData
    self.character:getModData().researchedSpecimens = self.character:getModData().researchedSpecimens or {}
    self.character:getModData().researchedSpecimens[researchKey] = true
    
    -- Track plants for Herbalist unlock
    local plantType = nil
    if ZScienceSkill.herbalistPlants and ZScienceSkill.herbalistPlants[fullType] then
        plantType = fullType
    end
    
    if plantType then
        self.character:getModData().researchedPlants = self.character:getModData().researchedPlants or {}
        
        if not self.character:getModData().researchedPlants[plantType] then
            self.character:getModData().researchedPlants[plantType] = true
            
            -- Count unique plants researched
            local count = 0
            for _ in pairs(self.character:getModData().researchedPlants) do
                count = count + 1
            end
            
            local required = ZScienceSkill.herbalistPlantsRequired or 10
            local hasHerbalist = self.character:isRecipeActuallyKnown("Herbalist")
            
            -- Grant Herbalist recipe and trait if threshold reached
            if count >= required and not hasHerbalist then
                self.character:learnRecipe("Herbalist")
                if not self.character:hasTrait(CharacterTrait.HERBALIST) then
                    self.character:getCharacterTraits():add(CharacterTrait.HERBALIST)
                end
                -- Sync recipes (0x01) and traits (0x02) to client
                sendSyncPlayerFields(self.character, 0x00000003)
                -- Notify client to show unlock UI
                sendServerCommand(self.character, "ZScienceSkill", "herbalistUnlocked", {})
            elseif not hasHerbalist then
                -- Notify client to show progress hint
                sendServerCommand(self.character, "ZScienceSkill", "herbalistProgress", { count = count })
            end
        end
    end
    
    -- Sync ModData from server to client
    self.character:transmitModData()
    
    return true
end

function ISResearchSpecimen:perform()
    self.character:setReading(false)
    self.item:setJobDelta(0.0)
    
    -- Sync item with server
    syncItemFields(self.character, self.item)
    
    ISBaseTimedAction.perform(self)
end

function ISResearchSpecimen:getDuration()
    if self.character:isTimedActionInstant() then return 1 end
    
    local baseTime = 300
    local scienceLevel = self.character:getPerkLevel(Perks.Science)
    local reduction = 1 - (scienceLevel * 0.05)
    return baseTime * reduction
end

function ISResearchSpecimen:new(character, item)
    local o = ISBaseTimedAction.new(self, character)
    o.character = character
    o.playerNum = character:getPlayerNum()
    o.item = item
    o.ignoreHandsWounds = true
    o.maxTime = o:getDuration()
    o.caloriesModifier = 0.5
    o.forceProgressBar = true
    return o
end

function ISResearchSpecimen.isResearched(character, item)
    local modData = character:getModData().researchedSpecimens
    if not modData then return false end
    
    local fullType = item:getFullType()
    
    -- Check specimen research key (may differ from fullType if 'key' is set)
    local researchKey = getSpecimenResearchKey(fullType)
    if modData[researchKey] then return true end
    
    -- Check fluid type
    local fluidType = ZScienceSkill.getFluidType(item)
    if fluidType and modData["Fluid:" .. fluidType] then return true end
    
    return false
end

function ISResearchSpecimen.isSpecimen(item)
    -- Check item type
    if ZScienceSkill.Data.specimens[item:getFullType()] then return true end
    
    -- Check fluid type
    local fluidType = ZScienceSkill.getFluidType(item)
    if fluidType and ZScienceSkill.Data.fluids and ZScienceSkill.Data.fluids[fluidType] then return true end
    
    return false
end

-- Helper function to add menu option (enabled or disabled)
local function addMenuOption(context, item, playerObj, disableReason, cb)
    if not item then return nil end
    
    local option
    if disableReason then
        option = context:addOption(getText("ContextMenu_ResearchSpecimen"), nil, nil)
        option.notAvailable = true
        local tooltip = ISToolTip:new()
        tooltip:setName(getText(disableReason))
        option.toolTip = tooltip
    else
        option = context:addOption(getText("ContextMenu_ResearchSpecimen"), playerObj, cb, item)
    end
    
    local scriptItem = item.getScriptItem and item:getScriptItem()
    if scriptItem and scriptItem.getNormalTexture then
        option.iconTexture = scriptItem:getNormalTexture()
    end
    
    return option
end

-- Context menu hook
local function onFillInventoryContextMenu(player, context, items)
    local playerObj = getSpecificPlayer(player)
    
    for _, v in ipairs(items) do
        local item = v
        if not instanceof(v, "InventoryItem") then
            item = v.items[1]
        end

        if ISResearchSpecimen.isSpecimen(item) then
            local disableReason = nil
            if ISResearchSpecimen.isResearched(playerObj, item) then
                disableReason = "Tooltip_AlreadyResearched"
            elseif playerObj:tooDarkToRead() then
                disableReason = "ContextMenu_TooDark"
            elseif not findNearbyMicroscope(playerObj) then
                disableReason = "Tooltip_NeedMicroscope"
            end
            
            local cb = function(pl, itm)
                    ISTimedActionQueue.add(ISResearchSpecimen:new(pl, itm))
            end
            
            addMenuOption(context, item, playerObj, disableReason, cb)
            break
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(onFillInventoryContextMenu)

-- Find all unresearched specimens in player inventory
local function findUnresearchedSpecimens(playerObj)
    local specimens = {}
    local inventory = playerObj:getInventory()
    local items = inventory:getItems()
    local modData = playerObj:getModData().researchedSpecimens
    
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        local fullType = item:getFullType()
        
        -- Check regular specimens
        if ZScienceSkill.Data.specimens[fullType] then
            local researchKey = getSpecimenResearchKey(fullType)
            if not (modData and modData[researchKey]) then
                table.insert(specimens, item)
            end
        else
            -- Check fluid specimens
            local fluidType = ZScienceSkill.getFluidType(item)
            if fluidType and ZScienceSkill.Data.fluids and ZScienceSkill.Data.fluids[fluidType] then
                if not (modData and modData["Fluid:" .. fluidType]) then
                    table.insert(specimens, item)
                end
            end
        end
    end
    
    return specimens
end

-- World object context menu hook (for microscope)
local function onFillWorldObjectContextMenu(player, context, worldobjects, _test)
    -- Note: 'test' parameter is for controller prompts, but PZ automatically handles this
    -- by checking if menu options were added. No need to check ISWorldObjectContextMenu.Test.
    
    local playerObj = getSpecificPlayer(player)
    
    -- Find microscope in clicked objects
    local microscope = nil
    for _, obj in ipairs(worldobjects) do
        if isMicroscope(obj) then
            microscope = obj
            break
        end
    end
    
    if not microscope then return end
    
    local specimens = findUnresearchedSpecimens(playerObj)
    local spriteName = microscope:getSprite() and microscope:getSprite():getName()
    local tex = spriteName and getTexture(spriteName)
    local microscopeIcon = tex and tex:splitIcon()
    
    local option
    if #specimens == 0 then
        option = context:addOption(getText("ContextMenu_ResearchAll"), nil, nil)
        option.notAvailable = true
        local tooltip = ISToolTip:new()
        tooltip:setName(getText("Tooltip_NoSpecimens"))
        option.toolTip = tooltip
    elseif playerObj:tooDarkToRead() then
        option = context:addOption(getText("ContextMenu_ResearchAll"), nil, nil)
        option.notAvailable = true
        local tooltip = ISToolTip:new()
        tooltip:setName(getText("ContextMenu_TooDark"))
        option.toolTip = tooltip
    else
        option = context:addOption(getText("ContextMenu_ResearchAll") .. " (" .. #specimens .. ")", playerObj, function(pl)
            for _, item in ipairs(specimens) do
                ISTimedActionQueue.add(ISResearchSpecimen:new(pl, item))
            end
        end)
        local tooltip = ISToolTip:new()
        tooltip:setName(getText("Tooltip_ResearchAllDesc", #specimens))
        option.toolTip = tooltip
    end
    
    if option and microscopeIcon then
        option.iconTexture = microscopeIcon
    end
end

Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)
