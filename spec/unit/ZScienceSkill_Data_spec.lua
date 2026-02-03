-- zbtest: Test for ZScienceSkill_Data.lua
-- Validates data tables are correctly defined

require "ZScienceSkill_Data"

local errors = {}

-- Helper to add error
local function fail(msg)
    table.insert(errors, msg)
end

-- Test: ZScienceSkill.literature
if type(ZScienceSkill.literature) ~= "table" then
    fail("ZScienceSkill.literature is not a table")
else
    -- Check science book XP values
    if ZScienceSkill.literature["Base.Book_Science"] ~= 35 then
        fail("Base.Book_Science XP should be 35")
    end
    if ZScienceSkill.literature["Base.Paperback_Science"] ~= 30 then
        fail("Base.Paperback_Science XP should be 30")
    end
    if ZScienceSkill.literature["Base.Magazine_Science"] ~= 15 then
        fail("Base.Magazine_Science XP should be 15")
    end
    
    -- SciFi should give less XP than science books
    local scienceXP = ZScienceSkill.literature["Base.Book_Science"] or 0
    local scifiXP = ZScienceSkill.literature["Base.Book_SciFi"] or 0
    if scifiXP >= scienceXP then
        fail(string.format("SciFi XP (%d) should be less than Science XP (%d)", scifiXP, scienceXP))
    end
    
    -- All values should be positive numbers
    for key, xp in pairs(ZScienceSkill.literature) do
        if type(key) ~= "string" then
            fail("literature key should be string: " .. tostring(key))
        end
        if type(xp) ~= "number" or xp <= 0 then
            fail(string.format("literature[%s] should be positive number, got %s", key, tostring(xp)))
        end
    end
end

-- Test: ZScienceSkill.specimens
if type(ZScienceSkill.specimens) ~= "table" then
    fail("ZScienceSkill.specimens is not a table")
else
    local count = 0
    for itemType, xp in pairs(ZScienceSkill.specimens) do
        count = count + 1
        
        -- Should start with "Base."
        if not string.match(itemType, "^Base%.") then
            fail("Specimen item should start with 'Base.': " .. itemType)
        end
        
        -- XP should be positive
        if type(xp) ~= "number" or xp <= 0 then
            fail(string.format("specimens[%s] should be positive number", itemType))
        end
    end
    
    -- Brain specimen should be 60 XP (double base)
    if ZScienceSkill.specimens["Base.Specimen_Brain"] ~= 60 then
        fail("Base.Specimen_Brain should be 60 XP")
    end
    
    -- Meteorite should be 200 XP (rare)
    if ZScienceSkill.specimens["Base.LargeMeteorite"] ~= 200 then
        fail("Base.LargeMeteorite should be 200 XP")
    end
    
    -- Should have at least 50 specimens
    if count < 50 then
        fail(string.format("Expected at least 50 specimens, found %d", count))
    end
end

-- Test: ZScienceSkill.skillBookXP
if type(ZScienceSkill.skillBookXP) ~= "table" then
    fail("ZScienceSkill.skillBookXP is not a table")
else
    local expected = { [1] = 10, [3] = 20, [5] = 30, [7] = 40, [9] = 50 }
    for level, xp in pairs(expected) do
        if ZScienceSkill.skillBookXP[level] ~= xp then
            fail(string.format("skillBookXP[%d] should be %d", level, xp))
        end
    end
    
    -- Should increase with level
    if not (ZScienceSkill.skillBookXP[1] < ZScienceSkill.skillBookXP[3] and
            ZScienceSkill.skillBookXP[3] < ZScienceSkill.skillBookXP[5] and
            ZScienceSkill.skillBookXP[5] < ZScienceSkill.skillBookXP[7] and
            ZScienceSkill.skillBookXP[7] < ZScienceSkill.skillBookXP[9]) then
        fail("skillBookXP should increase with level")
    end
end

-- Test: ZScienceSkill.herbalistPlants
if type(ZScienceSkill.herbalistPlants) ~= "table" then
    fail("ZScienceSkill.herbalistPlants is not a table")
else
    local count = 0
    for plant, value in pairs(ZScienceSkill.herbalistPlants) do
        count = count + 1
        if value ~= true then
            fail(string.format("herbalistPlants[%s] should be true", plant))
        end
    end
    
    local required = ZScienceSkill.herbalistPlantsRequired or 10
    if count < required then
        fail(string.format("Expected at least %d herbalist plants, found %d", required, count))
    end
end

-- Test: ZScienceSkill.fluids
if type(ZScienceSkill.fluids) ~= "table" then
    fail("ZScienceSkill.fluids is not a table")
else
    -- Should have Acid and Blood
    if type(ZScienceSkill.fluids["Acid"]) ~= "table" then
        fail("fluids['Acid'] should be a table")
    end
    if type(ZScienceSkill.fluids["Blood"]) ~= "table" then
        fail("fluids['Blood'] should be a table")
    end
    
    -- All fluids should grant Science XP
    for fluidName, perks in pairs(ZScienceSkill.fluids) do
        if type(perks.Science) ~= "number" or perks.Science <= 0 then
            fail(string.format("fluids[%s].Science should be positive number", fluidName))
        end
    end
    
    -- SecretFlavoring should be 200 XP
    if ZScienceSkill.fluids["SecretFlavoring"] and 
       ZScienceSkill.fluids["SecretFlavoring"].Science ~= 200 then
        fail("SecretFlavoring Science XP should be 200")
    end
end

-- Return result
if #errors > 0 then
    return table.concat(errors, "\n")
end

return true
