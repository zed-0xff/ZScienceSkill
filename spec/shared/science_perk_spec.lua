-- Test that Science perk is properly defined and can receive XP
describe("Science perk", function()
    it("exists in Perks table", function()
        assert.is_not_nil(Perks.Science)
    end)
    
    it("can be retrieved from PerkFactory", function()
        local perk = PerkFactory.getPerk(Perks.Science)
        assert.is_not_nil(perk)
    end)
    
    it("has correct parent (Crafting)", function()
        local perk = PerkFactory.getPerk(Perks.Science)
        assert.eq(Perks.Crafting, perk:getParent())
    end)
end)

describe("Science XP multiplier sandbox option", function()
    it("exists", function()
        local option = getSandboxOptions():getOptionByName("XPMultiplier.Science")
        assert.is_not_nil(option, "XPMultiplier.Science sandbox option must exist for addXp to work")
    end)
    
    it("has default value of 1.0", function()
        local option = getSandboxOptions():getOptionByName("XPMultiplier.Science")
        assert.eq(1.0, option:getValue())
    end)
end)

return ZBSpec.runAsync()
