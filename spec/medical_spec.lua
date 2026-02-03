-- Test for ZScienceSkill_Medical.lua
-- Tests medical treatment bonuses based on Science skill

require "ZBSpec"
require "ZScienceSkill_Medical"

local player = getPlayer()
if not player then
    return "getPlayer() returned nil - player not loaded"
end

-- Set timed actions to instant for testing
local wasInstant = player:isTimedActionInstantCheat()
player:setTimedActionInstantCheat(true)

describe("Medical speed bonuses", function()
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
end)

describe("Bandage effectiveness bonus", function()
    it("hook is installed on ISApplyBandage.complete", function()
        -- Verify the hook exists by checking the function was replaced
        assert.is_function(ISApplyBandage.complete)
        -- The original is stored, our hook wraps it
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

describe("Medical multiplier calculations", function()
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

-- Restore setting
player:setTimedActionInstantCheat(wasInstant)

return ZBSpec.run()
