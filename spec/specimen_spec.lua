-- Integration tests for ZScienceSkill mod
-- Tests that require game state (player, items, etc.)

require "ZBSpec"
require "ZScienceSkill_Data"
require "ZScienceSkill_ResearchSpecimen"

local player = getPlayer()
if not player then
    return "getPlayer() returned nil - player not loaded"
end

describe("ISResearchSpecimen.isSpecimen", function()
    it("identifies Cricket as specimen", function()
        local cricket = instanceItem("Base.Cricket")
        assert.is_not_nil(cricket)
        assert.is_true(ISResearchSpecimen.isSpecimen(cricket))
    end)
    
    it("does not identify Axe as specimen", function()
        local axe = instanceItem("Base.Axe")
        assert.is_not_nil(axe)
        assert.is_false(ISResearchSpecimen.isSpecimen(axe))
    end)
end)

describe("ISResearchSpecimen.isResearched", function()
    it("returns false for new specimen", function()
        local specimen = instanceItem("Base.Specimen_Brain")
        assert.is_not_nil(specimen)
        -- Clear any existing research data
        player:getModData().researchedSpecimens = player:getModData().researchedSpecimens or {}
        player:getModData().researchedSpecimens[specimen:getFullType()] = nil
        
        assert.is_false(ISResearchSpecimen.isResearched(player, specimen))
    end)
    
    it("returns true after marking as researched", function()
        local specimen = instanceItem("Base.Specimen_Brain")
        assert.is_not_nil(specimen)
        
        player:getModData().researchedSpecimens = player:getModData().researchedSpecimens or {}
        player:getModData().researchedSpecimens[specimen:getFullType()] = true
        
        assert.is_true(ISResearchSpecimen.isResearched(player, specimen))
        
        -- Cleanup
        player:getModData().researchedSpecimens[specimen:getFullType()] = nil
    end)
end)

describe("Fluid detection", function()
    it("does not identify water bottle as specimen", function()
        local bottle = instanceItem("Base.WaterBottleFull")
        if bottle and bottle.getFluidContainer then
            local fc = bottle:getFluidContainer()
            if fc then
                assert.is_false(ISResearchSpecimen.isSpecimen(bottle))
            end
        end
    end)
end)

describe("ZScienceSkill.specimens data", function()
    it("all items have Base. prefix", function()
        for itemType, _ in pairs(ZScienceSkill.specimens) do
            assert.matches("^Base%.", itemType)
        end
    end)
    
    it("all items have positive XP", function()
        for itemType, xp in pairs(ZScienceSkill.specimens) do
            assert.is_number(xp)
            assert.greater_than(0, xp)
        end
    end)
end)

return ZBSpec.run()
