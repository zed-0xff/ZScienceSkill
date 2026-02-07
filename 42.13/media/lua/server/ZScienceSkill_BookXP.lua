-- Grant Science XP when reading skill books or science literature
require "ZScienceSkill/Data"

-- MP:
-- ISReadABook:perform()  is called on client ONLY
-- ISReadABook:complete() is called on server ONLY

-- SP: both are called, perform() -> complete()

-- supposed to run on server only
function ISReadABook:is_literature_read()
    local playerObj = self.character
    local item = self.item

    if not item then return true end
    if not item:IsLiterature() then return true end

    -- next is a copy of ISInventoryPane:isLiteratureRead(playerObj, item)
    local modData = item:hasModData() and item:getModData() or nil
    if modData ~= nil then
        if (modData.literatureTitle) and playerObj:isLiteratureRead(modData.literatureTitle) then return true end
        if (modData.printMedia ~= nil) and playerObj:isPrintMediaRead(modData.printMedia.title) then return true end
        if (modData.learnedRecipe ~= nil) and playerObj:getKnownRecipes():contains(modData.learnedRecipe) then return true end
    end
    local skillBook = SkillBook[item:getSkillTrained()]
    if (skillBook ~= nil) and (item:getMaxLevelTrained() < playerObj:getPerkLevel(skillBook.perk) + 1) then return true end
    if item:getNumberOfPages() > 0 then
        local startPage = self.startPage or playerObj:getAlreadyReadPages(item:getFullType()) or 0
        if startPage == item:getNumberOfPages() then return true end
    end
    if (item:getLearnedRecipes() ~= nil) and playerObj:getKnownRecipes():containsAll(item:getLearnedRecipes()) then return true end
    return false
end

local orig_complete = ISReadABook.complete
function ISReadABook:complete()
    local isAlreadyRead = self.isLiteratureRead
    if isAlreadyRead == nil then
        isAlreadyRead = self:is_literature_read()
    end

    local result = orig_complete(self) -- saves literature read flags

    local itemType = self.item:getFullType()

    -- Check if this is read-once literature (mod compatibility items)
    if ZScienceSkill.Data.literatureReadOnce[itemType] then
        local modData = self.character:getModData()
        modData.readLiteratureOnce = modData.readLiteratureOnce or {}
        if not modData.readLiteratureOnce[itemType] then
            modData.readLiteratureOnce[itemType] = true
            addXp(self.character, Perks.Science, ZScienceSkill.Data.literatureReadOnce[itemType])
            if isClient() then
                self.character:transmitModData()
            end
        end
    elseif not isAlreadyRead then
        -- Check if this is science literature
        if ZScienceSkill.Data.literature[itemType] then
            addXp(self.character, Perks.Science, ZScienceSkill.Data.literature[itemType])
        -- Check if this was a skill book
        elseif SkillBook and SkillBook[self.item:getSkillTrained()] and self.item:getSkillTrained() ~= "Science" then
            local lvl = self.item:getLvlSkillTrained() or 1
            local scienceXP = ZScienceSkill.skillBookXP[lvl] or 2
            addXp(self.character, Perks.Science, scienceXP)
        end
    end

    return result
end
