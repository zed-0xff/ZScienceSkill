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
            addXp(character, perk, bonusXP)
        end
    end
    updating = false
end

-- XXX logic changed after 42.13.1:
--
--  zombie/characters/IsoGameCharacter.java:
--    42.13.1:
--      12927-            if (!GameServer.server) {
--      12928:                LuaEventManager.triggerEventGarbage("AddXP", this.chr, type, Float.valueOf(amount));
--
--    unstable:
--      12940-            if (!GameClient.client) {
--      12941:                LuaEventManager.triggerEventGarbage("AddXP", this.chr, type, Float.valueOf(amount));

Events.AddXP.Add(onAddXP)
