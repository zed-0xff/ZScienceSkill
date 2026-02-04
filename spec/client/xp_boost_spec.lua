-- Integration tests for ZScienceSkill XP boost
-- Tests requiring player and game state - runs on client and SP only

require "ZBSpec"
require "ZScienceSkill_XPBoost"

ZBSpec.describe("Combat perk detection", function()
    it("Perks.Combat exists", function()
        assert.is_not_nil(Perks.Combat)
    end)
    
    it("Perks.Firearm exists", function()
        assert.is_not_nil(Perks.Firearm)
    end)
    
    it("PerkFactory.getPerk returns perk object", function()
        local perkObj = PerkFactory.getPerk(Perks.Woodwork)
        assert.is_not_nil(perkObj)
    end)
    
    it("Woodwork parent is not Combat", function()
        local perkObj = PerkFactory.getPerk(Perks.Woodwork)
        assert.is_not_nil(perkObj)
        local parent = perkObj:getParent()
        assert.is_true(parent ~= Perks.Combat and parent ~= Perks.Firearm)
    end)
end)

ZBSpec.player.describe("XP boost integration", function()
    local player = getPlayer()
    
    it("gaining Woodwork XP works (if Science > 0)", function()
        local scienceLevel = player:getPerkLevel(Perks.Science)
        
        -- Skip if no Science skill
        if scienceLevel == 0 then
            return
        end
        
        local woodworkBefore = player:getXp():getXP(Perks.Woodwork)
        
        -- Add some Woodwork XP
        player:getXp():AddXP(Perks.Woodwork, 100)
        
        local woodworkAfter = player:getXp():getXP(Perks.Woodwork)
        local gained = woodworkAfter - woodworkBefore
        
        -- Should gain XP (exact amount depends on game multipliers)
        assert.greater_than(0, gained)
    end)
end)

return ZBSpec.run()
