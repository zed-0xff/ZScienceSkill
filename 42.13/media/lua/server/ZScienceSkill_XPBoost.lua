-- Small boost to all non-combat XP based on Science level (2% per level)
require 'ZSS_Fix_Events'

if isClient() then return end

local updatingCharacters = {}
local sciencePerk = Perks.Science
local multiplier = 0.02 -- multiplier for the bonusXP per scienceLevel. 0.02 = 2%

local function onAddXP(character, perk, amount)
    -- prevent recursion
    if updatingCharacters[character] then return end

    -- Skip combat perks, Science itself, and negative XP
    if ZScienceSkill.isCombatPerk(perk) or perk == sciencePerk or amount <= 0 then
        return
    end

    local scienceLevel = character:getPerkLevel(sciencePerk)
    if scienceLevel < 1 then return end

    updatingCharacters[character] = true

    pcall(function()
        local bonusXP = amount * (scienceLevel * multiplier)


        if bonusXP >= ZScienceSkill.minGain then
            addXpNoMultiplier(character, perk, bonusXP)
        end
    end)

    updatingCharacters[character] = nil
end

ZSS_Fix_Events.AddXP.Add(onAddXP)
