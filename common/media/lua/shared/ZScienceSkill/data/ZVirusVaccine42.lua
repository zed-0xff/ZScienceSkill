-- ZVirusVaccine42 mod integration
require "ZScienceSkill/Data"

ZScienceSkill.Data.add({
    literatureReadOnce = {
        ["LabBooks.BkLaboratoryEquipment1"] = 30, -- lab equipment assembly
        ["LabBooks.BkLaboratoryEquipment2"] = 30, -- decorations assembly
        ["LabBooks.BkLaboratoryEquipment3"] = 30, -- glassware crafting
        ["LabBooks.BkVirologyCourses1"]     = 40, -- virology basics
        ["LabBooks.BkVirologyCourses2"]     = 50, -- advanced virology
        ["LabBooks.BkChemistryCourse"]      = 40, -- chemistry
    },
    specimens = {
        -- Human brains (autopsy)
        ["LabItems.HumanBrainLow"]       = { Science = 40, Doctor = 30 },
        ["LabItems.HumanBrainMid"]       = { Science = 50, Doctor = 40 },
        ["LabItems.HumanBrainHigh"]      = { Science = 60, Doctor = 50 },
        ["LabItems.RottenHumanBrain"]    = { Science = 20, Doctor = 10 },
        -- Human skulls & bones
        ["LabItems.LabHumanSkullWithBrain"] = { Science = 50, Doctor = 40 },
        ["LabItems.LabHumanSkull"]       = { Science = 30, Doctor = 20 },
        ["LabItems.LabHumanSkullFixed"]  = { Science = 35, Doctor = 25 },
        ["LabItems.LabHumanSkullPart"]   = { Science = 15, Doctor = 10 },
        ["LabItems.LabHumanBoneLarge"]   = { Science = 20, Doctor = 15 },
        ["LabItems.LabRegularHumanBone"] = { Science = 15, Doctor = 10 },
        ["LabItems.LabSmallRandomHumanBones"] = { Science = 10, Doctor = 5 },
        ["LabItems.LabHumanTeeth"]       = { Science = 10, Doctor = 10 },
        -- Blood samples
        ["LabItems.MatInfectedBlood"]    = { Science = 30, Doctor = 25 },
        ["LabItems.MatTaintedBlood"]     = { Science = 35, Doctor = 30 },
        -- Chemicals (Science only)
        ["LabItems.ChHydrochloricAcidCan"] = 50,
        ["LabItems.ChSulfuricAcidCan"]     = 50,
        ["LabItems.ChSodiumHydroxideBag"]  = 40,
        ["LabItems.ChAmmonia"]             = 40,
    },
})
