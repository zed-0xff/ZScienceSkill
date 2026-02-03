-- Test for ZScienceSkill_Data.lua
-- Run with: busted tests/unit/ZScienceSkill_Data_spec.lua

describe("ZScienceSkill.literature", function()
    setup(function()
        -- Add the mod's lua path to package.path
        package.path = package.path .. ";42.13/media/lua/shared/?.lua"
        
        -- Load the data module (sets global ZScienceSkill)
        require("ZScienceSkill_Data")
    end)
    
    it("should be a table", function()
        assert.is_table(ZScienceSkill.literature)
    end)
    
    it("should define XP for science books", function()
        assert.equals(35, ZScienceSkill.literature["Base.Book_Science"])
        assert.equals(30, ZScienceSkill.literature["Base.Paperback_Science"])
        assert.equals(15, ZScienceSkill.literature["Base.Magazine_Science"])
    end)
    
    it("should give more XP for science books than sci-fi books", function()
        local science_xp = ZScienceSkill.literature["Base.Book_Science"]
        local scifi_xp = ZScienceSkill.literature["Base.Book_SciFi"]
        
        assert.is_true(science_xp > scifi_xp)
    end)
    
    it("should contain only string keys", function()
        for key, _ in pairs(ZScienceSkill.literature) do
            assert.is_string(key)
        end
    end)
    
    it("should contain only positive number values", function()
        for _, xp in pairs(ZScienceSkill.literature) do
            assert.is_number(xp)
            assert.is_true(xp > 0, "XP should be positive")
        end
    end)
end)

describe("ZScienceSkill.specimens", function()
    setup(function()
        package.path = package.path .. ";42.13/media/lua/shared/?.lua"
        require("ZScienceSkill_Data")
    end)
    
    it("should be a table", function()
        assert.is_table(ZScienceSkill.specimens)
    end)
    
    it("should contain items with 'Base.' prefix", function()
        for itemType, _ in pairs(ZScienceSkill.specimens) do
            assert.matches("^Base%.", itemType, 
                "Item '" .. itemType .. "' should start with 'Base.'")
        end
    end)
    
    it("should have positive XP values for all specimens", function()
        for itemType, xp in pairs(ZScienceSkill.specimens) do
            assert.is_number(xp, "XP for " .. itemType .. " should be a number")
            assert.is_true(xp > 0, "XP for " .. itemType .. " should be positive")
        end
    end)
    
    it("should grant double XP for brain specimens", function()
        assert.equals(60, ZScienceSkill.specimens["Base.Specimen_Brain"])
    end)
    
    it("should grant special XP for rare items", function()
        assert.equals(200, ZScienceSkill.specimens["Base.LargeMeteorite"])
    end)
    
    it("should have at least 50 researchable specimens", function()
        local count = 0
        for _ in pairs(ZScienceSkill.specimens) do
            count = count + 1
        end
        
        assert.is_true(count >= 50, 
            "Expected at least 50 specimens, found " .. count)
    end)
end)

describe("ZScienceSkill.skillBookXP", function()
    setup(function()
        package.path = package.path .. ";42.13/media/lua/shared/?.lua"
        require("ZScienceSkill_Data")
    end)
    
    it("should define XP for each skill book level", function()
        assert.equals(10, ZScienceSkill.skillBookXP[1])
        assert.equals(20, ZScienceSkill.skillBookXP[3])
        assert.equals(30, ZScienceSkill.skillBookXP[5])
        assert.equals(40, ZScienceSkill.skillBookXP[7])
        assert.equals(50, ZScienceSkill.skillBookXP[9])
    end)
    
    it("should increase XP for higher level books", function()
        assert.is_true(ZScienceSkill.skillBookXP[1] < ZScienceSkill.skillBookXP[3])
        assert.is_true(ZScienceSkill.skillBookXP[3] < ZScienceSkill.skillBookXP[5])
        assert.is_true(ZScienceSkill.skillBookXP[5] < ZScienceSkill.skillBookXP[7])
        assert.is_true(ZScienceSkill.skillBookXP[7] < ZScienceSkill.skillBookXP[9])
    end)
end)

describe("ZScienceSkill.herbalistPlants", function()
    setup(function()
        package.path = package.path .. ";42.13/media/lua/shared/?.lua"
        require("ZScienceSkill_Data")
    end)
    
    it("should contain at least 10 plants for herbalist unlock", function()
        local count = 0
        for _ in pairs(ZScienceSkill.herbalistPlants) do
            count = count + 1
        end
        
        assert.is_true(count >= ZScienceSkill.herbalistPlantsRequired,
            string.format("Expected at least %d plants, found %d", 
                ZScienceSkill.herbalistPlantsRequired, count))
    end)
    
    it("should have true value for all herbalist plants", function()
        for plant, value in pairs(ZScienceSkill.herbalistPlants) do
            assert.is_true(value, plant .. " should be marked as true")
        end
    end)
end)

describe("ZScienceSkill.fluids", function()
    setup(function()
        package.path = package.path .. ";42.13/media/lua/shared/?.lua"
        require("ZScienceSkill_Data")
    end)
    
    it("should define researchable fluids", function()
        assert.is_table(ZScienceSkill.fluids)
        assert.is_table(ZScienceSkill.fluids["Acid"])
        assert.is_table(ZScienceSkill.fluids["Blood"])
    end)
    
    it("should grant Science XP for all fluids", function()
        for fluidName, perks in pairs(ZScienceSkill.fluids) do
            assert.is_number(perks.Science, 
                "Fluid '" .. fluidName .. "' should grant Science XP")
            assert.is_true(perks.Science > 0)
        end
    end)
    
    it("should grant bonus XP for special fluids", function()
        assert.equals(200, ZScienceSkill.fluids["SecretFlavoring"].Science)
    end)
end)
