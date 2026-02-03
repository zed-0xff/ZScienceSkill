-- Test for ZScienceSkill_ElectricalXP.lua
-- Verifies Science XP is granted when gaining Electrical XP

require "ZBSpec"
require "ZScienceSkill_ElectricalXP"

local player = getPlayer()
if not player then
    return "getPlayer() returned nil - player not loaded"
end

describe("Electrical XP synergy", function()
    it("grants Science XP when gaining Electrical XP", function()
        local scienceBefore = player:getXp():getXP(Perks.Science)
        
        -- Add Electrical XP
        player:getXp():AddXP(Perks.Electricity, 100)
        
        local scienceAfter = player:getXp():getXP(Perks.Science)
        local scienceGained = scienceAfter - scienceBefore
        
        -- Should gain some Science XP (approximately 50% of Electrical)
        assert.greater_than(0, scienceGained)
    end)
    
    it("grants less Science XP than the Electrical XP added", function()
        local scienceBefore = player:getXp():getXP(Perks.Science)
        
        -- Add a known amount of Electrical XP
        player:getXp():AddXP(Perks.Electricity, 200)
        
        local scienceGained = player:getXp():getXP(Perks.Science) - scienceBefore
        
        -- Science gained should be positive but less than 200 (the raw electrical amount)
        -- The hook grants 50% of the raw amount, so max would be 100
        assert.greater_than(0, scienceGained)
        assert.is_true(scienceGained < 200, "Science XP should be less than Electrical XP added")
    end)
    
    it("does not grant Science XP for zero Electrical XP", function()
        local scienceBefore = player:getXp():getXP(Perks.Science)
        
        -- Add zero Electrical XP
        player:getXp():AddXP(Perks.Electricity, 0)
        
        local scienceAfter = player:getXp():getXP(Perks.Science)
        
        assert.is_equal(scienceBefore, scienceAfter)
    end)
end)

return ZBSpec.run()
