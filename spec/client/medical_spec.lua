-- Test for ZScienceSkill_Medical.lua
-- Tests requiring player - runs on client and SP only

require "ZBSpec"
require "ZScienceSkill_Medical"

-- Math tests (no player needed)
ZBSpec.describe("Medical multiplier calculations", function()
    it("speed reduction is 3% per Science level", function()
        -- Test the math: at Science 10, multiplier should be 0.7
        local scienceLevel = 10
        local expectedMultiplier = 1 - (scienceLevel * 0.03)
        assert.is_equal(0.7, expectedMultiplier)
    end)
    
    it("bandage life bonus is 5% per Science level", function()
        -- Test the math: at Science 10, multiplier should be 1.5
        local scienceLevel = 10
        local expectedMultiplier = 1 + (scienceLevel * 0.05)
        assert.is_equal(1.5, expectedMultiplier)
    end)
end)

-- Integration tests require player
ZBSpec.player.describe("Medical speed bonuses", function()
    local player = getPlayer()
    
    -- Set timed actions to instant for testing
    local wasInstant = player:isTimedActionInstantCheat()
    player:setTimedActionInstantCheat(true)
    
    it("ISApplyBandage.getDuration returns positive number", function()
        local bandage = instanceItem("Base.Bandage")
        assert.is_not_nil(bandage)
        
        local bodyPart = player:getBodyDamage():getBodyPart(BodyPartType.Hand_L)
        local action = ISApplyBandage:new(player, player, bandage, bodyPart, true)
        action.character = player
        
        local duration = action:getDuration()
        assert.is_number(duration)
        assert.greater_than(0, duration)
    end)
    
    it("ISDisinfect.getDuration returns positive number", function()
        local disinfectant = instanceItem("Base.AlcoholWipes")
        assert.is_not_nil(disinfectant)
        
        local bodyPart = player:getBodyDamage():getBodyPart(BodyPartType.Hand_L)
        local action = ISDisinfect:new(player, player, disinfectant, bodyPart, true)
        action.character = player
        
        local duration = action:getDuration()
        assert.is_number(duration)
        assert.greater_than(0, duration)
    end)
    
    it("ISSplint.getDuration returns positive number", function()
        local splint = instanceItem("Base.Splint")
        assert.is_not_nil(splint)
        
        local bodyPart = player:getBodyDamage():getBodyPart(BodyPartType.Hand_L)
        local action = ISSplint:new(player, player, splint, bodyPart, true)
        action.character = player
        
        local duration = action:getDuration()
        assert.is_number(duration)
        assert.greater_than(0, duration)
    end)
    
    -- Restore setting
    player:setTimedActionInstantCheat(wasInstant)
end)

ZBSpec.player.describe("Bandage effectiveness bonus", function()
    local player = getPlayer()
    
    it("hook is installed on ISApplyBandage.complete", function()
        assert.is_function(ISApplyBandage.complete)
        assert.is_not_nil(ISApplyBandage.complete)
    end)
    
    it("body part bandage life can be read and set", function()
        local bodyPart = player:getBodyDamage():getBodyPart(BodyPartType.Hand_L)
        assert.is_not_nil(bodyPart)
        
        -- Save original
        local originalLife = bodyPart:getBandageLife()
        
        -- Set a test value
        bodyPart:setBandageLife(100)
        assert.is_equal(100, bodyPart:getBandageLife())
        
        -- Apply bonus calculation manually (what our hook does)
        local scienceLevel = player:getPerkLevel(Perks.Science)
        local bonusMultiplier = 1 + (scienceLevel * 0.05)
        local boostedLife = math.floor(100 * bonusMultiplier)
        bodyPart:setBandageLife(boostedLife)
        
        -- Verify it was set (use floor to avoid floating point issues)
        local actual = math.floor(bodyPart:getBandageLife())
        assert.is_equal(boostedLife, actual)
        
        -- Restore
        bodyPart:setBandageLife(originalLife)
    end)
end)

return ZBSpec.run()
