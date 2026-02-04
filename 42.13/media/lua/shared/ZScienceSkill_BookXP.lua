-- Grant Science XP when reading skill books or science literature
require "ZScienceSkill_Data"

-- MP:
-- ISReadABook:perform()  is called on client ONLY
-- ISReadABook:complete() is called on server ONLY

-- SP: both are called, perform() -> complete()

-- supposed to run on server only
local function is_literature_read(playerObj, item)
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
    if (item:getNumberOfPages() > 0) and (playerObj:getAlreadyReadPages(item:getFullType()) == item:getNumberOfPages()) then return true end
    if (item:getLearnedRecipes() ~= nil) and playerObj:getKnownRecipes():containsAll(item:getLearnedRecipes()) then return true end
    return false
end

local orig_complete = ISReadABook.complete
function ISReadABook:complete()
    if self.isLiteratureRead == nil then
        self.isLiteratureRead = is_literature_read(self.character, self.item)
    end

    local result = orig_complete(self) -- saves literature read flags

    if not self.isLiteratureRead then
        local itemType = self.item:getFullType()
        print("ISReadABook:complete", "itemType", itemType)

        -- Check if this is science literature
        if ZScienceSkill.literature[itemType] then
            print("ISReadABook:complete", "science literature", ZScienceSkill.literature[itemType])
            addXp(self.character, Perks.Science, ZScienceSkill.literature[itemType])
        -- Check if this was a skill book
        elseif SkillBook and SkillBook[self.item:getSkillTrained()] and self.item:getSkillTrained() ~= "Science" then
            local lvl = self.item:getLvlSkillTrained() or 1
            local scienceXP = ZScienceSkill.skillBookXP[lvl] or 2
            addXp(self.character, Perks.Science, scienceXP)
        end
    end

    return result
end
