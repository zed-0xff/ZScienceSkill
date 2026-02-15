-- Test for ZScienceSkill/Data.lua
-- Validates data tables are correctly defined

describe("ZScienceSkill.Data.literature", function()
    it("is a table", function()
        assert.is_table(ZScienceSkill.Data.literature)
    end)
    
    it("has correct science book XP values", function()
        assert.eq(35, ZScienceSkill.Data.literature["Base.Book_Science"])
        assert.eq(30, ZScienceSkill.Data.literature["Base.Paperback_Science"])
        assert.eq(15, ZScienceSkill.Data.literature["Base.Magazine_Science"])
    end)
    
    it("gives more XP for science books than scifi", function()
        local scienceXP = ZScienceSkill.Data.literature["Base.Book_Science"]
        local scifiXP = ZScienceSkill.Data.literature["Base.Book_SciFi"]
        assert.gt(scienceXP, scifiXP, "Science books should give more XP than Sci-Fi books")
    end)
    
    it("has all positive number values", function()
        for key, xp in pairs(ZScienceSkill.Data.literature) do
            assert.is_string(key)
            assert.is_number(xp)
            assert.gt(xp, 0)
        end
    end)
end)

describe("ZScienceSkill.skillBookXP", function()
    it("is a table", function()
        assert.is_table(ZScienceSkill.skillBookXP)
    end)
    
    it("has correct XP progression", function()
        assert.eq(10, ZScienceSkill.skillBookXP[1])
        assert.eq(20, ZScienceSkill.skillBookXP[3])
        assert.eq(30, ZScienceSkill.skillBookXP[5])
        assert.eq(40, ZScienceSkill.skillBookXP[7])
        assert.eq(50, ZScienceSkill.skillBookXP[9])
    end)
    
    it("increases with level", function()
        assert.lt(ZScienceSkill.skillBookXP[1], ZScienceSkill.skillBookXP[3])
        assert.lt(ZScienceSkill.skillBookXP[3], ZScienceSkill.skillBookXP[5])
        assert.lt(ZScienceSkill.skillBookXP[5], ZScienceSkill.skillBookXP[7])
        assert.lt(ZScienceSkill.skillBookXP[7], ZScienceSkill.skillBookXP[9])
    end)
end)

describe("ZScienceSkill.herbalistPlants", function()
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

describe("ZScienceSkill.Data.fluids", function()
    it("is a table", function()
        assert.is_table(ZScienceSkill.Data.fluids)
    end)
    
    it("has Acid and Blood", function()
        assert.is_table(ZScienceSkill.Data.fluids["Acid"])
        assert.is_table(ZScienceSkill.Data.fluids["Blood"])
    end)
    
    it("all fluids grant positive Science XP", function()
        for fluidName, perks in pairs(ZScienceSkill.Data.fluids) do
            assert.is_number(perks.Science)
            assert.gt(perks.Science, 0)
        end
    end)
    
    it("SecretFlavoring grants 200 Science XP", function()
        assert.is_not_nil(ZScienceSkill.Data.fluids["SecretFlavoring"])
        assert.eq(200, ZScienceSkill.Data.fluids["SecretFlavoring"].Science)
    end)
end)

return ZBSpec.run()
