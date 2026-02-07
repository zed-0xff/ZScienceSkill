ZBSpec.describe("ZScienceSkill.Data.specimens data", function()
    it("is a table", function()
        assert.is_table(ZScienceSkill.Data.specimens)
    end)
    
    it("all items have Base. prefix", function()
        for itemType, _ in pairs(ZScienceSkill.Data.specimens) do
            assert.matches("^Base%.", itemType)
        end
    end)
    
    it("all items have positive XP", function()
        for itemType, xp in pairs(ZScienceSkill.Data.specimens) do
            assert.is_number(xp)
            assert.greater_than(0, xp)
        end
    end)
    
    it("has correct XP for special specimens", function()
        assert.is_equal(60, ZScienceSkill.Data.specimens["Base.Specimen_Brain"])
        assert.is_equal(200, ZScienceSkill.Data.specimens["Base.LargeMeteorite"])
    end)
    
    it("has at least 50 specimens", function()
        local count = 0
        for _ in pairs(ZScienceSkill.Data.specimens) do
            count = count + 1
        end
        assert.is_true(count >= 50, "Expected at least 50 specimens, found " .. count)
    end)
end)

return ZBSpec.run()
