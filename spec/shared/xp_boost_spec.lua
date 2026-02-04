-- Math tests for ZScienceSkill XP boost
-- Pure calculations - runs everywhere (SP, MP client, MP server)

require "ZBSpec"

ZBSpec.describe("XP boost multiplier calculation", function()
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

ZBSpec.describe("Bonus XP calculation", function()
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

return ZBSpec.run()
