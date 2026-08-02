-- Grant Science XP when gaining Electrical XP

require 'ZSS_Fix_Events'

if isClient() then return end

ZScienceSkill = ZScienceSkill or {}
ZScienceSkill.minGain = 1
local scienceXPMultiplier = 0.5 -- 0.5 = 50% ElectricalXP to ScienceXP

-- This function is called 2 times when gaining ElectricalXP: ElectricalXP = 100 / scienceXP = 50. XPBoost ElectricalXP = 20 / ScienceXP = 10 || That's expected?
local function onAddXP(character, perk, amount)
    if perk == Perks.Electricity and amount >= ZScienceSkill.minGain then
        local scienceXP = amount * scienceXPMultiplier

        if scienceXP >= ZScienceSkill.minGain then
            addXpNoMultiplier(character, Perks.Science, scienceXP)
        end
    end
end

ZSS_Fix_Events.AddXP.Add(onAddXP)
