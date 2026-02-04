-- Test for ZScienceSkill_Data.lua
-- Validates data tables are correctly defined

require "ZBSpec"
require "ZScienceSkill_Data"

ZBSpec.describe("ZScienceSkill.literature", function()
    it("is a table", function()
        assert.is_table(ZScienceSkill.literature)
    end)
    
    it("has correct science book XP values", function()
        assert.is_equal(35, ZScienceSkill.literature["Base.Book_Science"])
        assert.is_equal(30, ZScienceSkill.literature["Base.Paperback_Science"])
        assert.is_equal(15, ZScienceSkill.literature["Base.Magazine_Science"])
    end)
    
    it("gives more XP for science books than scifi", function()
        local scienceXP = ZScienceSkill.literature["Base.Book_Science"]
        local scifiXP = ZScienceSkill.literature["Base.Book_SciFi"]
        assert.greater_than(scifiXP, scienceXP)
    end)
    
    it("has all positive number values", function()
        for key, xp in pairs(ZScienceSkill.literature) do
            assert.is_string(key)
            assert.is_number(xp)
            assert.greater_than(0, xp)
        end
    end)
end)

ZBSpec.describe("ZScienceSkill.specimens", function()
    it("is a table", function()
        assert.is_table(ZScienceSkill.specimens)
    end)
    
    it("has all items with Base. prefix and positive XP", function()
        for itemType, xp in pairs(ZScienceSkill.specimens) do
            assert.matches("^Base%.", itemType)
            assert.is_number(xp)
            assert.greater_than(0, xp)
        end
    end)
    
    it("has correct XP for special specimens", function()
        assert.is_equal(60, ZScienceSkill.specimens["Base.Specimen_Brain"])
        assert.is_equal(200, ZScienceSkill.specimens["Base.LargeMeteorite"])
    end)
    
    it("has at least 50 specimens", function()
        local count = 0
        for _ in pairs(ZScienceSkill.specimens) do
            count = count + 1
        end
        assert.is_true(count >= 50, "Expected at least 50 specimens, found " .. count)
    end)
end)

ZBSpec.describe("ZScienceSkill.skillBookXP", function()
    it("is a table", function()
        assert.is_table(ZScienceSkill.skillBookXP)
    end)
    
    it("has correct XP progression", function()
        assert.is_equal(10, ZScienceSkill.skillBookXP[1])
        assert.is_equal(20, ZScienceSkill.skillBookXP[3])
        assert.is_equal(30, ZScienceSkill.skillBookXP[5])
        assert.is_equal(40, ZScienceSkill.skillBookXP[7])
        assert.is_equal(50, ZScienceSkill.skillBookXP[9])
    end)
    
    it("increases with level", function()
        assert.less_than(ZScienceSkill.skillBookXP[3], ZScienceSkill.skillBookXP[1])
        assert.less_than(ZScienceSkill.skillBookXP[5], ZScienceSkill.skillBookXP[3])
        assert.less_than(ZScienceSkill.skillBookXP[7], ZScienceSkill.skillBookXP[5])
        assert.less_than(ZScienceSkill.skillBookXP[9], ZScienceSkill.skillBookXP[7])
    end)
end)

ZBSpec.describe("ZScienceSkill.herbalistPlants", function()
    it("is a table", function()
        assert.is_table(ZScienceSkill.herbalistPlants)
    end)
    
    it("has all values set to true", function()
        for plant, value in pairs(ZScienceSkill.herbalistPlants) do
            assert.is_true(value, plant .. " should be true")
        end
    end)
    
    it("has at least required number of plants", function()
        local count = 0
        for _ in pairs(ZScienceSkill.herbalistPlants) do
            count = count + 1
        end
        local required = ZScienceSkill.herbalistPlantsRequired or 10
        assert.is_true(count >= required, "Expected at least " .. required .. " plants, found " .. count)
    end)
end)

ZBSpec.describe("ZScienceSkill.fluids", function()
    it("is a table", function()
        assert.is_table(ZScienceSkill.fluids)
    end)
    
    it("has Acid and Blood", function()
        assert.is_table(ZScienceSkill.fluids["Acid"])
        assert.is_table(ZScienceSkill.fluids["Blood"])
    end)
    
    it("all fluids grant positive Science XP", function()
        for fluidName, perks in pairs(ZScienceSkill.fluids) do
            assert.is_number(perks.Science)
            assert.greater_than(0, perks.Science)
        end
    end)
    
    it("SecretFlavoring grants 200 Science XP", function()
        assert.is_not_nil(ZScienceSkill.fluids["SecretFlavoring"])
        assert.is_equal(200, ZScienceSkill.fluids["SecretFlavoring"].Science)
    end)
end)

return ZBSpec.run()
