-- Grant Science XP when reading skill books or science literature
require "ZScienceSkill_Data"

local originalComplete = ISReadABook.complete

function ISReadABook:complete()
    local result = originalComplete(self)

    local itemType = self.item:getFullType()

    -- Check if this is science literature
    if ZScienceSkill.literature[itemType] then
        addXp(self.character, Perks.Science, ZScienceSkill.literature[itemType])
    -- Check if this was a skill book (not our own Science books)
    elseif SkillBook and SkillBook[self.item:getSkillTrained()] and self.item:getSkillTrained() ~= "Science" then
        local lvl = self.item:getLvlSkillTrained() or 1
        local scienceXP = ZScienceSkill.skillBookXP[lvl] or 2
        addXp(self.character, Perks.Science, scienceXP)
    end

    return result
end
