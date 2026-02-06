-- Server-side command handler for ZScienceSkill
-- Handles ModData sync from clients in multiplayer

require "ZScienceSkill_Data"

local MODULE = "ZScienceSkill"

local function handleResearchSpecimen(player, args)
    if not args or not args.researchKey then return end
    
    player:getModData().researchedSpecimens = player:getModData().researchedSpecimens or {}
    player:getModData().researchedSpecimens[args.researchKey] = true
    
    -- Track plants for Herbalist unlock
    if args.plantType then
        player:getModData().researchedPlants = player:getModData().researchedPlants or {}
        
        if not player:getModData().researchedPlants[args.plantType] then
            player:getModData().researchedPlants[args.plantType] = true
        end
    end
end

local function handleGrantHerbalist(player, args)
    -- Grant Herbalist recipe and trait
    player:learnRecipe("Herbalist")
    if not player:hasTrait(CharacterTrait.HERBALIST) then
        player:getCharacterTraits():add(CharacterTrait.HERBALIST)
    end
end

Events.OnClientCommand.Add(function(module, command, player, args)
    if module ~= MODULE then return end
    
    if command == "researchSpecimen" then
        handleResearchSpecimen(player, args)
    elseif command == "grantHerbalist" then
        handleGrantHerbalist(player, args)
    end
end)
