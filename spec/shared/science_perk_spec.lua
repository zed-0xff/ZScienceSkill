-- Test that Science perk is properly defined and can receive XP
ZBSpec.describe("Science perk", function()
    it("exists in Perks table", function()
        assert.is_not_nil(Perks.Science)
    end)
    
    it("can be retrieved from PerkFactory", function()
        local perk = PerkFactory.getPerk(Perks.Science)
        assert.is_not_nil(perk)
    end)
    
    it("has correct parent (Crafting)", function()
        local perk = PerkFactory.getPerk(Perks.Science)
        assert.is_equal(Perks.Crafting, perk:getParent())
    end)
end)

ZBSpec.describe("Science XP multiplier sandbox option", function()
    it("exists", function()
        local option = getSandboxOptions():getOptionByName("XPMultiplier.Science")
        assert.is_not_nil(option, "XPMultiplier.Science sandbox option must exist for addXp to work")
    end)
    
    it("has default value of 1.0", function()
        local option = getSandboxOptions():getOptionByName("XPMultiplier.Science")
        assert.is_equal(1.0, option:getValue())
    end)
end)

ZBSpec.client.describe("addXp for Science perk", function()
    local player = get_player()
    
    before_each(function()
        init_player(player)
    end)
    
    it("works without error", function()
        local xpBefore = player:getXp():getXP(Perks.Science)
        
        -- This should not throw NullPointerException
        addXp(player, Perks.Science, 10)
        
        local xpAfter = player:getXp():getXP(Perks.Science)
        assert.greater_than(xpBefore, xpAfter)
    end)
end)

return ZBSpec.run()
