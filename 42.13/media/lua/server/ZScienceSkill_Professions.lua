-- Applies profPreResearchedSpecimens[profId] for the player's profession on new game / game start.
-- Data is registered by integration data files (e.g. ZScienceSkill/data/ResearchLabInternProfession.lua).
local function getProfessionId(player)
    if not player or not player.getDescriptor then return nil end
    local prof = player:getDescriptor():getCharacterProfession()
    return tostring(prof)
end

local function applyPreResearchedSpecimens(player)
    local profId = getProfessionId(player)
    if not profId then return end

    local modData = player:getModData()
    modData.ZScienceSkill_ProfPreResearched = modData.ZScienceSkill_ProfPreResearched or {}
    if modData.ZScienceSkill_ProfPreResearched[profId] then return end

    local keys = ZScienceSkill.Data.profPreResearchedSpecimens and ZScienceSkill.Data.profPreResearchedSpecimens[profId]
    if not keys or #keys == 0 then return end

    modData.researchedSpecimens = modData.researchedSpecimens or {}
    for _, key in ipairs(keys) do
        modData.researchedSpecimens[key] = true
    end
    modData.ZScienceSkill_ProfPreResearched[profId] = true
    player:transmitModData()
end

local function onNewGame()
    local player = getPlayer()
    if player then applyPreResearchedSpecimens(player) end
end

local function onGameStart()
    local player = getPlayer()
    if player then applyPreResearchedSpecimens(player) end
end

Events.OnNewGame.Add(onNewGame)
Events.OnGameStart.Add(onGameStart)
