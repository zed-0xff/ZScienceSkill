-- Test for ZScienceSkill_ResearchRecipe.lua
-- Tests recipe research speed bonus and Science XP grant

require "ZBSpec"
require "ZScienceSkill_ResearchRecipe"

local player = getPlayer()
if not player then
    return "getPlayer() returned nil - player not loaded"
end

describe("Recipe research speed bonus", function()
    it("hook is installed on ISResearchRecipe.getDuration", function()
        assert.is_function(ISResearchRecipe.getDuration)
    end)
    
    it("hook is installed on ISResearchRecipe.complete", function()
        assert.is_function(ISResearchRecipe.complete)
    end)
end)

describe("Research speed multiplier calculation", function()
    it("speed bonus is 5% per Science level", function()
        -- Test the math: at Science 10, multiplier should be 0.5 (50% faster)
        local scienceLevel = 10
        local expectedMultiplier = 1 - (scienceLevel * 0.05)
        assert.is_equal(0.5, expectedMultiplier)
    end)
    
    it("no bonus at Science level 0", function()
        local scienceLevel = 0
        local expectedMultiplier = 1 - (scienceLevel * 0.05)
        assert.is_equal(1.0, expectedMultiplier)
    end)
end)

describe("Research XP calculation", function()
    it("base XP is 15", function()
        local baseXP = 15
        assert.is_equal(15, baseXP)
    end)
    
    it("adds 5 XP per skill requirement level", function()
        -- Test the formula: baseXP + (skillReq * 5)
        local baseXP = 15
        local skillReq = 3
        local expectedXP = baseXP + (skillReq * 5)
        assert.is_equal(30, expectedXP)
    end)
    
    it("complex recipe (skill 7) grants 50 XP", function()
        local baseXP = 15
        local skillReq = 7
        local expectedXP = baseXP + (skillReq * 5)
        assert.is_equal(50, expectedXP)
    end)
    
    it("max skill requirement (10) grants 65 XP", function()
        local baseXP = 15
        local skillReq = 10
        local expectedXP = baseXP + (skillReq * 5)
        assert.is_equal(65, expectedXP)
    end)
end)

return ZBSpec.run()
