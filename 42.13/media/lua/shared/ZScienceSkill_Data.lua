ZScienceSkill = ZScienceSkill or {}

-- Science literature items and their XP rewards
ZScienceSkill.literature = {
    ["Base.Book_Science"]         = 25,
    ["Base.Paperback_Science"]    = 20,
    ["Base.Magazine_Science"]     = 10,
    ["Base.Magazine_Science_New"] = 10,
}

local specimenXP = 30

-- Specimen jars that can be researched
ZScienceSkill.specimens = {
    ["Base.Animal_Brain"] = specimenXP * 1.5,
    ["Base.Animal_Brain_Small"] = specimenXP,
    ["Base.Hominid_Skull"] = specimenXP,
    ["Base.Hominid_Skull_Fragment"] = specimenXP * 0.5,
    ["Base.Hominid_Skull_Partial"] = specimenXP * 0.75,
    ["Base.Specimen_Insects"] = specimenXP,
    ["Base.Specimen_Beetles"] = specimenXP,
    ["Base.Specimen_Butterflies"] = specimenXP,
    ["Base.Specimen_Centipedes"] = specimenXP,
    ["Base.Specimen_Tapeworm"] = specimenXP,
    ["Base.Specimen_Minerals"] = specimenXP,
    ["Base.Specimen_Octopus"] = specimenXP,
    ["Base.Specimen_FetalCalf"] = specimenXP,
    ["Base.Specimen_FetalLamb"] = specimenXP,
    ["Base.Specimen_FetalPiglet"] = specimenXP,
    ["Base.Specimen_MonkeyHead"] = specimenXP,
    ["Base.Specimen_Brain"] = specimenXP * 2,
}

-- Skill book XP by level (any skill book grants small Science XP)
ZScienceSkill.skillBookXP = {
    [1] = 10,  -- Vol. 1
    [3] = 20,  -- Vol. 2
    [5] = 30,  -- Vol. 3
    [7] = 40,  -- Vol. 4
    [9] = 50,  -- Vol. 5
}
