-- Grant Science XP when reading skill books or science literature
require "ZScienceSkill_Data"

-- MP:
-- ISReadABook:perform()  is called on client ONLY
-- ISReadABook:complete() is called on server ONLY

-- SP: both are called, perform() -> complete()


local orig_complete = ISReadABook.complete
function ISReadABook:complete()
    local result = orig_complete(self)

    print("ISReadABook:complete", self.isLiteratureRead)

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
