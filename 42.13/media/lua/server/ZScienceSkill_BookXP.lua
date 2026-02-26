-- Grant Science XP when reading skill books or science literature
require "ZScienceSkill/Data"
require 'zsHook'

-- MP:
-- ISReadABook:perform()  is called on client ONLY
-- ISReadABook:complete() is called on server ONLY

-- SP: both are called, perform() -> complete()

zsHook(ISReadABook, {
    complete = function(orig, self)
        local isAlreadyRead = self.isLiteratureRead -- may be set by ISReadABook:perform(), but not in all contexts
        if isAlreadyRead == nil then
            isAlreadyRead = ZScienceSkill.isLiteratureRead(self.character, self.item, self.startPage)
        end

        local result = orig(self) -- saves literature read flags
        local itemType = self.item:getFullType()

        -- Check if this is read-once literature (mod compatibility items)
        if ZScienceSkill.Data.literatureReadOnce[itemType] then
            local modData = self.character:getModData()
            modData.researchedSpecimens = modData.researchedSpecimens or {}
            if not modData.researchedSpecimens[itemType] then
                modData.researchedSpecimens[itemType] = true
                addXp(self.character, Perks.Science, ZScienceSkill.Data.literatureReadOnce[itemType])
                if isClient() then
                    self.character:transmitModData()
                end
            end
        elseif isAlreadyRead == false then -- strict comparison, to not grant extra XP when status is unknown
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
    end -- complete
}) -- zsHook
