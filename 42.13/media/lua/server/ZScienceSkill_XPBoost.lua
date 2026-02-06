-- Small boost to all non-combat XP based on Science level (2% per level)

local updating = false

local function onAddXP(character, perk, amount)
    -- prevent recursion
    if updating then return end
    
    -- Skip combat perks, Science itself, and negative XP
    if ZScienceSkill.isCombatPerk(perk) or perk == Perks.Science or amount <= 0 then
        return
    end
    
    updating = true
    local scienceLevel = character:getPerkLevel(Perks.Science)
    if scienceLevel > 0 then
        local bonusPercent = scienceLevel * 0.02  -- 2% per level
        local bonusXP = amount * bonusPercent
        if bonusXP >= ZScienceSkill.minGain then
            -- Use direct AddXP to avoid triggering event again
            addXp(character, perk, bonusXP)
        end
    end
    updating = false
end

Events.AddXP.Add(onAddXP)
