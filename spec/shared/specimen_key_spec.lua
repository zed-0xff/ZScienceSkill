-- Test that specimens with shared 'key' field are tracked together
ZBSpec.describe("Specimen shared key", function()
    it("vinegar items share the same research key", function()
        local config1 = ZScienceSkill.Data.specimens["Base.Vinegar2"]
        local config2 = ZScienceSkill.Data.specimens["Base.Vinegar_Jug"]
        
        assert.is_table(config1, "Base.Vinegar2 should be defined")
        assert.is_table(config2, "Base.Vinegar_Jug should be defined")
        assert.is_equal("Vinegar", config1.key)
        assert.is_equal("Vinegar", config2.key)
    end)
    
    it("vinegar items grant Science XP", function()
        local config1 = ZScienceSkill.Data.specimens["Base.Vinegar2"]
        local config2 = ZScienceSkill.Data.specimens["Base.Vinegar_Jug"]
        
        assert.is_equal(20, config1.Science)
        assert.is_equal(20, config2.Science)
    end)
    
    it("baking soda is a simple specimen without key", function()
        local config = ZScienceSkill.Data.specimens["Base.BakingSoda"]
        assert.is_equal(20, config)
    end)
end)

ZBSpec.describe("Specimen research with shared key", function()
    local player
    
    before_each(function()
        player = getPlayer()
        player:getModData().researchedSpecimens = nil
    end)
    
    it("researching one vinegar marks the shared key as researched", function()
        local modData = player:getModData()
        modData.researchedSpecimens = {}
        modData.researchedSpecimens["Vinegar"] = true
        
        -- Both items should now be considered researched
        local vinegar2 = InventoryItemFactory.CreateItem("Base.Vinegar2")
        local vinegarJug = InventoryItemFactory.CreateItem("Base.Vinegar_Jug")
        
        assert.is_true(ISResearchSpecimen.isResearched(player, vinegar2))
        assert.is_true(ISResearchSpecimen.isResearched(player, vinegarJug))
    end)
    
    it("items without shared key use fullType as research key", function()
        local modData = player:getModData()
        modData.researchedSpecimens = {}
        modData.researchedSpecimens["Base.BakingSoda"] = true
        
        local bakingSoda = InventoryItemFactory.CreateItem("Base.BakingSoda")
        assert.is_true(ISResearchSpecimen.isResearched(player, bakingSoda))
    end)
    
    it("unresearched vinegar is not marked as researched", function()
        local vinegar2 = InventoryItemFactory.CreateItem("Base.Vinegar2")
        assert.is_false(ISResearchSpecimen.isResearched(player, vinegar2))
    end)
end)

return ZBSpec.run()
