-- Load in-game tests when in debug mode
-- Add to your main mod file (ZScienceSkill_Main.lua or similar)

if isDebugEnabled() then
    require "tests/ingame/ZScienceSkillTests"
end
