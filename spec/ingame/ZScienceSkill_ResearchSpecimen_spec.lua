-- zbtest: Integration tests for ZScienceSkill mod
-- Tests that require game state (player, items, etc.)

require "ZScienceSkill_Data"
require "ZScienceSkill_ResearchSpecimen"

local player = getPlayer()
if not player then
    return "getPlayer() returned nil - player not loaded"
end

local errors = {}

-- Test: ISResearchSpecimen.isSpecimen correctly identifies specimens
local cricket = instanceItem("Base.Cricket")
if cricket then
    if not ISResearchSpecimen.isSpecimen(cricket) then
        table.insert(errors, "Cricket should be identified as specimen")
    end
else
    table.insert(errors, "Failed to create Cricket item")
end

local nonSpecimen = instanceItem("Base.Axe")
if nonSpecimen then
    if ISResearchSpecimen.isSpecimen(nonSpecimen) then
        table.insert(errors, "Axe should NOT be identified as specimen")
    end
end

-- Test: ISResearchSpecimen.isResearched works correctly
local specimen = instanceItem("Base.Specimen_Brain")
if specimen then
    -- Should not be researched initially
    if ISResearchSpecimen.isResearched(player, specimen) then
        table.insert(errors, "New specimen should not be marked as researched")
    end
    
    -- Mark as researched in player moddata
    player:getModData().researchedSpecimens = player:getModData().researchedSpecimens or {}
    player:getModData().researchedSpecimens[specimen:getFullType()] = true
    
    -- Now should be researched
    if not ISResearchSpecimen.isResearched(player, specimen) then
        table.insert(errors, "Specimen should be marked as researched after adding to moddata")
    end
    
    -- Cleanup
    player:getModData().researchedSpecimens[specimen:getFullType()] = nil
end

-- Test: Fluid detection works
if ZScienceSkill.fluids then
    -- Create a container with fluid (if possible)
    local bottle = instanceItem("Base.WaterBottleFull")
    if bottle and bottle.getFluidContainer then
        local fc = bottle:getFluidContainer()
        if fc then
            -- Bottle has water, which is not in our fluids table
            if ISResearchSpecimen.isSpecimen(bottle) then
                table.insert(errors, "Water bottle should NOT be a specimen (Water not in fluids)")
            end
        end
    end
end

-- Test: All specimens in data have valid Base. prefix
for itemType, xp in pairs(ZScienceSkill.specimens) do
    if not string.match(itemType, "^Base%.") then
        table.insert(errors, "Specimen missing Base. prefix: " .. itemType)
    end
    if type(xp) ~= "number" or xp <= 0 then
        table.insert(errors, "Invalid XP for specimen: " .. itemType)
    end
end

-- Return result
if #errors > 0 then
    return table.concat(errors, "\n")
end

return true
