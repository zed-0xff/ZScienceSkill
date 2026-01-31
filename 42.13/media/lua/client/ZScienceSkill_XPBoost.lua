-- Small boost to all non-combat XP based on Science level (2% per level)

local function isCombatPerk(perk)
    local perkObj = PerkFactory.getPerk(perk)
    if not perkObj then return false end
    
    local parent = perkObj:getParent()
    return parent == Perks.Combat or parent == Perks.Firearm
           or perk == Perks.Combat or perk == Perks.Firearm
end

local function onAddXP(character, perk, amount)
    -- Skip combat perks, Science itself, and negative XP
    if isCombatPerk(perk) or perk == Perks.Science or amount <= 0 then
        return
    end
    
    local scienceLevel = character:getPerkLevel(Perks.Science)
    if scienceLevel > 0 then
        local bonusPercent = scienceLevel * 0.02  -- 2% per level
        local bonusXP = amount * bonusPercent
        if bonusXP >= 0.5 then
            -- Use direct AddXP to avoid triggering event again
            character:getXp():AddXP(perk, bonusXP)
        end
    end
end

Events.AddXP.Add(onAddXP)
