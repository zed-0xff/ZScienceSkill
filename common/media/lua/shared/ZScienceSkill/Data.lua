ZScienceSkill = ZScienceSkill or {}

ZScienceSkill.Data = {
    literature = {},
    specimens = {},
    fluids = {},
    skillBookXP = {},
    herbalistPlants = {},
    herbalistPlantsRequired = 0,
    trackingXP = 0,
    medicalXP = 0,
    literatureReadOnce = {},
}

function ZScienceSkill.Data.add(tables)
    for data_key, values_tbl in pairs(tables) do
        if ZScienceSkill.Data[data_key] then
            for k, v in pairs(values_tbl) do
                ZScienceSkill.Data[data_key][k] = v
            end
        else
            print("ZScienceSkill.Data.add: target not found for key: " .. data_key)
        end
    end
end


-- Skill book XP by level (any skill book grants small Science XP)
ZScienceSkill.skillBookXP = {
    [1] = 10,  -- Vol. 1
    [3] = 20,  -- Vol. 2
    [5] = 30,  -- Vol. 3
    [7] = 40,  -- Vol. 4
    [9] = 50,  -- Vol. 5
}

-- Plants that count toward Herbalist unlock (research 10 unique to learn)
ZScienceSkill.herbalistPlants = {
    -- Berries
    ["Base.BeautyBerry"] = true,
    ["Base.HollyBerry"] = true,
    ["Base.WinterBerry"] = true,
    ["Base.BerryBlack"] = true,
    ["Base.BerryBlue"] = true,
    ["Base.BerryGeneric1"] = true,
    ["Base.BerryGeneric2"] = true,
    ["Base.BerryGeneric3"] = true,
    ["Base.BerryGeneric4"] = true,
    ["Base.BerryGeneric5"] = true,
    ["Base.BerryPoisonIvy"] = true,
    -- Mushrooms
    ["Base.MushroomGeneric1"] = true,
    ["Base.MushroomGeneric2"] = true,
    ["Base.MushroomGeneric3"] = true,
    ["Base.MushroomGeneric4"] = true,
    ["Base.MushroomGeneric5"] = true,
    ["Base.MushroomGeneric6"] = true,
    ["Base.MushroomGeneric7"] = true,
    ["Base.MushroomsButton"] = true,
    -- Medicinal plants
    ["Base.BlackSage"] = true,
    ["Base.CommonMallow"] = true,
    ["Base.Comfrey"] = true,
    ["Base.Ginseng"] = true,
    ["Base.LemonGrass"] = true,
    ["Base.Plantain"] = true,
    ["Base.WildGarlic2"] = true,
    -- Wild plants
    ["Base.Acorn"] = true,
    ["Base.Dandelions"] = true,
    ["Base.GrapeLeaves"] = true,
    ["Base.Nettles"] = true,
    ["Base.Rosehips"] = true,
    ["Base.Thistle"] = true,
    ["Base.Violets"] = true,
}
ZScienceSkill.herbalistPlantsRequired = 10

-- Scat analysis grants Tracking XP (items matching "Dung_" pattern)
ZScienceSkill.trackingXP = 15

-- Pharmacology grants Doctor XP (items matching "Pills" pattern)
ZScienceSkill.medicalXP = 20

-- Fluids that can be researched (in any container)
-- Fluids: fluid_name => { perk_name => xp, ... }
ZScienceSkill.fluids = {
    -- vanilla
    ["Acid"]            = { Science = 50 },
    ["Blood"]           = { Science = 50, Doctor = 50 },
    ["SecretFlavoring"] = { Science = 200, Cooking = 50 },
    -- Project Summer Car
    ["Antifreeze"]      = { Science = 30, Mechanics = 30 },
    ["ATF"]             = { Science = 30, Mechanics = 30 },
    ["MotorOil"]        = { Science = 30, Mechanics = 30 },
    ["UsedMotorOil"]    = { Science = 30, Maintenance = 30 },
    -- Sewing Workbranch
    ["MachineOil"]      = { Science = 30, Maintenance = 30 },
}
