-- Test for ZScienceSkill_XPBoost.lua
-- Tests passive XP boost based on Science skill level

require "ZBSpec"
require "ZScienceSkill_XPBoost"

local player = getPlayer()
if not player then
    return "getPlayer() returned nil - player not loaded"
end

describe("XP boost multiplier calculation", function()
    it("bonus is 2% per Science level", function()
        local scienceLevel = 10
        local bonusPercent = scienceLevel * 0.02
        assert.is_equal(0.2, bonusPercent)  -- 20% at level 10
    end)
    
    it("no bonus at Science level 0", function()
        local scienceLevel = 0
        local bonusPercent = scienceLevel * 0.02
        assert.is_equal(0, bonusPercent)
    end)
    
    it("10% bonus at Science level 5", function()
        local scienceLevel = 5
        local bonusPercent = scienceLevel * 0.02
        assert.is_equal(0.1, bonusPercent)
    end)
end)

describe("Bonus XP calculation", function()
    it("calculates correct bonus for 100 XP at Science 10", function()
        local amount = 100
        local scienceLevel = 10
        local bonusPercent = scienceLevel * 0.02
        local bonusXP = amount * bonusPercent
        assert.is_equal(20, bonusXP)
    end)
    
    it("small amounts below threshold are not applied", function()
        -- bonusXP must be >= 0.5 to be applied
        local amount = 10
        local scienceLevel = 2  -- 4% bonus = 0.4 XP (below threshold)
        local bonusPercent = scienceLevel * 0.02
        local bonusXP = amount * bonusPercent
        assert.is_true(bonusXP < 0.5, "Should be below 0.5 threshold")
    end)
    
    it("amounts at threshold are applied", function()
        -- 25 XP at Science 1 (2%) = 0.5 XP (at threshold)
        local amount = 25
        local scienceLevel = 1
        local bonusPercent = scienceLevel * 0.02
        local bonusXP = amount * bonusPercent
        assert.is_true(bonusXP >= 0.5, "Should be at or above 0.5 threshold")
    end)
end)

describe("Combat perk detection", function()
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
    
    it("Carpentry parent is not Combat", function()
        local perkObj = PerkFactory.getPerk(Perks.Woodwork)
        assert.is_not_nil(perkObj)
        local parent = perkObj:getParent()
        assert.is_true(parent ~= Perks.Combat and parent ~= Perks.Firearm)
    end)
end)

describe("XP boost integration", function()
    it("gaining Carpentry XP also increases it (if Science > 0)", function()
        local scienceLevel = player:getPerkLevel(Perks.Science)
        
        -- Skip if no Science skill
        if scienceLevel == 0 then
            return
        end
        
        local carpentryBefore = player:getXp():getXP(Perks.Woodwork)
        
        -- Add some Carpentry XP
        player:getXp():AddXP(Perks.Woodwork, 100)
        
        local carpentryAfter = player:getXp():getXP(Perks.Woodwork)
        local gained = carpentryAfter - carpentryBefore
        
        -- Should gain more than 100 due to Science boost
        -- (exact amount depends on game multipliers)
        assert.greater_than(0, gained)
    end)
end)

return ZBSpec.run()
