require "TimedActions/ISBaseTimedAction"
require "ZScienceSkill_Data"

ISResearchSpecimen = ISBaseTimedAction:derive("ISResearchSpecimen")

local SEARCH_RADIUS = 1

-- Find a microscope within radius of player
local function findNearbyMicroscope(character)
    local sq = character:getSquare()
    if not sq then return nil end
    
    local sx, sy, sz = sq:getX(), sq:getY(), sq:getZ()
    
    for x = sx - SEARCH_RADIUS, sx + SEARCH_RADIUS do
        for y = sy - SEARCH_RADIUS, sy + SEARCH_RADIUS do
            local checkSq = getCell():getGridSquare(x, y, sz)
            if checkSq then
                for i = 0, checkSq:getObjects():size() - 1 do
                    local obj = checkSq:getObjects():get(i)
                    if obj and obj.getProperties and obj:getProperties():get("CustomName") == "Microscope" then
                        return obj
                    end
                end
            end
        end
    end
    return nil
end

function ISResearchSpecimen:isValid()
    if not self.character:getInventory():contains(self.item) then
        return false
    end
    if not findNearbyMicroscope(self.character) then
        HaloTextHelper.addBadText(self.character, getText("Tooltip_NeedMicroscope"))
        return false
    end
    if self.character:tooDarkToRead() then
        HaloTextHelper.addBadText(self.character, getText("ContextMenu_TooDark"))
        return false
    end
    return true
end

function ISResearchSpecimen:start()
    self.item:setJobType(getText("ContextMenu_ResearchSpecimen"))
    self.item:setJobDelta(0.0)
    self:setActionAnim(CharacterActionAnims.Craft)
    self:setOverrideHandModels(nil, self.item)
end

function ISResearchSpecimen:update()
    self.item:setJobDelta(self:getJobDelta())
end

function ISResearchSpecimen:stop()
    self.item:setJobDelta(0.0)
    ISBaseTimedAction.stop(self)
end

function ISResearchSpecimen:perform()
    self.item:setJobDelta(0.0)
    
    local fullType = self.item:getFullType()
    local xp = ZScienceSkill.specimens[fullType]
    
    self.character:getXp():AddXP(Perks.Science, xp)
    HaloTextHelper.addTextWithArrow(self.character, getText("IGUI_perks_Science") .. " +" .. xp, true, HaloTextHelper.getColorGreen())
    
    -- Grant Tracking XP for scat analysis (dung items)
    if fullType:find("Dung_") and ZScienceSkill.trackingXP then
        self.character:getXp():AddXP(Perks.Tracking, ZScienceSkill.trackingXP)
        HaloTextHelper.addTextWithArrow(self.character, getText("IGUI_perks_Tracking") .. " +" .. ZScienceSkill.trackingXP, true, HaloTextHelper.getColorGreen())
    end
    
    -- Grant Doctor XP for pharmacology (pills)
    if fullType:find("Pills") and ZScienceSkill.medicalXP then
        self.character:getXp():AddXP(Perks.Doctor, ZScienceSkill.medicalXP)
        HaloTextHelper.addTextWithArrow(self.character, getText("IGUI_perks_Doctor") .. " +" .. ZScienceSkill.medicalXP, true, HaloTextHelper.getColorGreen())
    end
    
    self.character:getModData().researchedSpecimens = self.character:getModData().researchedSpecimens or {}
    self.character:getModData().researchedSpecimens[fullType] = true
    
    -- Track plants for Herbalist unlock
    if ZScienceSkill.herbalistPlants and ZScienceSkill.herbalistPlants[fullType] then
        self.character:getModData().researchedPlants = self.character:getModData().researchedPlants or {}
        
        if not self.character:getModData().researchedPlants[fullType] then
            self.character:getModData().researchedPlants[fullType] = true
            
            -- Count unique plants researched
            local count = 0
            for _ in pairs(self.character:getModData().researchedPlants) do
                count = count + 1
            end
            
            local required = ZScienceSkill.herbalistPlantsRequired or 10
            
            -- Check if player already has Herbalist
            if not self.character:isRecipeActuallyKnown("Herbalist") then
                if count >= required then
                    -- Grant Herbalist recipe and trait
                    self.character:learnRecipe("Herbalist")
                    if not self.character:hasTrait(CharacterTrait.HERBALIST) then
                        self.character:getCharacterTraits():add(CharacterTrait.HERBALIST)
                    end
                    self.character:playSound("GainExperienceLevel")
                    HaloTextHelper.addTextWithArrow(self.character, getText("IGUI_HerbalistUnlocked"), true, HaloTextHelper.getColorGreen())
                elseif count <= 3 then
                    self.character:Say(getText("IGUI_HerbalistHint1"))
                elseif count <= 5 then
                    self.character:Say(getText("IGUI_HerbalistHint2"))
                elseif count <= 9 then
                    self.character:Say(getText("IGUI_HerbalistHint3"))
                end
            end
        end
    end
    
    ISBaseTimedAction.perform(self)
end

function ISResearchSpecimen:getDuration()
    if self.character:isTimedActionInstant() then return 1 end
    
    local baseTime = 300
    local scienceLevel = self.character:getPerkLevel(Perks.Science)
    local reduction = 1 - (scienceLevel * 0.05)
    return baseTime * reduction
end

function ISResearchSpecimen:new(character, item)
    local o = ISBaseTimedAction.new(self, character)
    o.item = item
    o.maxTime = o:getDuration()
    o.forceProgressBar = true
    return o
end

function ISResearchSpecimen.isResearched(character, item)
    local modData = character:getModData().researchedSpecimens
    return modData and modData[item:getFullType()]
end

function ISResearchSpecimen.isSpecimen(item)
    return ZScienceSkill.specimens[item:getFullType()]
end

-- Helper function to add menu option (enabled or disabled)
local function addMenuOption(context, item, playerObj, disableReason, cb)
    if not item then return nil end
    
    local option
    if disableReason then
        option = context:addOption(getText("ContextMenu_ResearchSpecimen"), nil, nil)
        option.notAvailable = true
        local tooltip = ISToolTip:new()
        tooltip:setName(getText(disableReason))
        option.toolTip = tooltip
    else
        option = context:addOption(getText("ContextMenu_ResearchSpecimen"), playerObj, cb, item)
    end
    
    local scriptItem = item.getScriptItem and item:getScriptItem()
    if scriptItem and scriptItem.getNormalTexture then
        option.iconTexture = scriptItem:getNormalTexture()
    end
    
    return option
end

-- Context menu hook
local function onFillInventoryContextMenu(player, context, items)
    local playerObj = getSpecificPlayer(player)
    
    for _, v in ipairs(items) do
        local item = v
        if not instanceof(v, "InventoryItem") then
            item = v.items[1]
        end

        if ISResearchSpecimen.isSpecimen(item) then
            local disableReason = nil
            if ISResearchSpecimen.isResearched(playerObj, item) then
                disableReason = "Tooltip_AlreadyResearched"
            elseif playerObj:tooDarkToRead() then
                disableReason = "ContextMenu_TooDark"
            elseif not findNearbyMicroscope(playerObj) then
                disableReason = "Tooltip_NeedMicroscope"
            end
            
            local cb = function(pl, itm)
                    ISTimedActionQueue.add(ISResearchSpecimen:new(pl, itm))
            end
            
            addMenuOption(context, item, playerObj, disableReason, cb)
            break
        end
    end
end

Events.OnFillInventoryObjectContextMenu.Add(onFillInventoryContextMenu)

-- Check if object is a microscope
local function isMicroscope(obj)
    return obj and obj.getProperties and obj:getProperties():get("CustomName") == "Microscope"
end

-- Find all unresearched specimens in player inventory
local function findUnresearchedSpecimens(playerObj)
    local specimens = {}
    local inventory = playerObj:getInventory()
    local items = inventory:getItems()
    
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        local fullType = item:getFullType()
        if ZScienceSkill.specimens[fullType] then
            local modData = playerObj:getModData().researchedSpecimens
            if not (modData and modData[fullType]) then
                table.insert(specimens, item)
            end
        end
    end
    
    return specimens
end

-- World object context menu hook (for microscope)
local function onFillWorldObjectContextMenu(player, context, worldobjects, test)
    local playerObj = getSpecificPlayer(player)
    
    -- Find microscope in clicked objects
    local microscope = nil
    for _, obj in ipairs(worldobjects) do
        if isMicroscope(obj) then
            microscope = obj
            break
        end
    end
    
    if not microscope then return end
    
    local specimens = findUnresearchedSpecimens(playerObj)
    local spriteName = microscope:getSprite() and microscope:getSprite():getName()
    local tex = spriteName and getTexture(spriteName)
    local microscopeIcon = tex and tex:splitIcon()
    
    local option
    if #specimens == 0 then
        option = context:addOption(getText("ContextMenu_ResearchAll"), nil, nil)
        option.notAvailable = true
        local tooltip = ISToolTip:new()
        tooltip:setName(getText("Tooltip_NoSpecimens"))
        option.toolTip = tooltip
    elseif playerObj:tooDarkToRead() then
        option = context:addOption(getText("ContextMenu_ResearchAll"), nil, nil)
        option.notAvailable = true
        local tooltip = ISToolTip:new()
        tooltip:setName(getText("ContextMenu_TooDark"))
        option.toolTip = tooltip
    else
        option = context:addOption(getText("ContextMenu_ResearchAll") .. " (" .. #specimens .. ")", playerObj, function(pl)
            for _, item in ipairs(specimens) do
                ISTimedActionQueue.add(ISResearchSpecimen:new(pl, item))
            end
        end)
        local tooltip = ISToolTip:new()
        tooltip:setName(getText("Tooltip_ResearchAllDesc", #specimens))
        option.toolTip = tooltip
    end
    
    if option and microscopeIcon then
        option.iconTexture = microscopeIcon
    end
end

Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)
