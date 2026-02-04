-- Integration tests for ZScienceSkill specimens
-- Tests requiring player - runs on client and SP only

require "ZBSpec"
require "ZScienceSkill_Data"
require "ZScienceSkill_ISResearchSpecimen"

ZBSpec.player.describe("ISResearchSpecimen.isSpecimen", function()
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

ZBSpec.player.describe("ISResearchSpecimen.isResearched", function()
    local player = getPlayer()
    
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

ZBSpec.player.describe("Fluid detection", function()
    it("Axe is not a specimen", function()
        local axe = instanceItem("Base.Axe")
        assert.is_false(ISResearchSpecimen.isSpecimen(axe))
    end)
end)

return ZBSpec.run()
