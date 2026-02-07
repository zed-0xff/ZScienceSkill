ZBSpec.describe("ZScienceSkill.Data.specimens data", function()
    it("is a table", function()
        assert.is_table(ZScienceSkill.Data.specimens)
    end)
    
    it("has items with Base. prefix", function()
        local found = false
        for itemType, _ in pairs(ZScienceSkill.Data.specimens) do
            assert.matches("^Base%.", itemType)
            if string.match(itemType, "^Base%.") then
                found = true
            end
        end
        assert(found, "Expected at least one item with 'Base.' prefix")
    end)
    
    it("has numeric positive XP", function()
        local found = false
        for itemType, xp in pairs(ZScienceSkill.Data.specimens) do
            if type(xp) == "number" and xp > 0 then
                found = true
            end
        end
        assert(found, "Expected at least one specimen with positive numeric XP")
    end)
    
    it("has correct XP for special specimens", function()
        assert.is_equal(60, ZScienceSkill.Data.specimens["Base.Specimen_Brain"]["Science"])
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
