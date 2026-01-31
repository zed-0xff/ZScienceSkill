ZScienceSkill = ZScienceSkill or {}

-- Science literature items and their XP rewards
ZScienceSkill.literature = {
    ["Base.Book_Science"]         = 25,
    ["Base.Paperback_Science"]    = 20,
    ["Base.Magazine_Science"]     = 10,
    ["Base.Magazine_Science_New"] = 10,
}

local specimenXP = 30
local insectXP = 8
local berryXP = 5
local mushroomXP = 10
local gemXP = 30
local crystalXP = 15
local coinXP = 15
local herbXP = 10
local plantXP = 6
local seafoodXP = 10
local smallCorpseXP = 12

-- Specimen jars and biological items that can be researched
ZScienceSkill.specimens = {
    -- Preserved specimens
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
    
    -- Animal brains & skulls
    ["Base.Animal_Brain"] = specimenXP * 1.5,
    ["Base.Animal_Brain_Small"] = specimenXP,
    ["Base.Hominid_Skull"] = specimenXP,
    ["Base.Hominid_Skull_Fragment"] = specimenXP * 0.5,
    ["Base.Hominid_Skull_Partial"] = specimenXP * 0.75,
    
    -- Insects (entomology)
    ["Base.AmericanLadyCaterpillar"] = insectXP,
    ["Base.BandedWoolyBearCaterpillar"] = insectXP,
    ["Base.Centipede"] = insectXP,
    ["Base.Centipede2"] = insectXP,
    ["Base.Cockroach"] = insectXP,
    ["Base.Cricket"] = insectXP,
    ["Base.Grasshopper"] = insectXP,
    ["Base.Ladybug"] = insectXP,
    ["Base.Leech"] = insectXP,
    ["Base.Maggots"] = insectXP * 0.5,
    ["Base.Millipede"] = insectXP,
    ["Base.Millipede2"] = insectXP,
    ["Base.MonarchCaterpillar"] = insectXP,
    ["Base.Pillbug"] = insectXP * 0.5,
    ["Base.SawflyLarva"] = insectXP,
    ["Base.SilkMothCaterpillar"] = insectXP,
    ["Base.SwallowtailCaterpillar"] = insectXP,
    ["Base.Termites"] = insectXP,
    ["Base.Worm"] = insectXP * 0.5,
    
    -- Berries (botany)
    ["Base.BeautyBerry"] = berryXP,
    ["Base.HollyBerry"] = berryXP,
    ["Base.WinterBerry"] = berryXP,
    ["Base.BerryBlack"] = berryXP,
    ["Base.BerryBlue"] = berryXP,
    ["Base.BerryGeneric1"] = berryXP * 2,  -- Unknown berry, more XP for identification
    ["Base.BerryGeneric2"] = berryXP * 2,
    ["Base.BerryGeneric3"] = berryXP * 2,
    ["Base.BerryGeneric4"] = berryXP * 2,
    ["Base.BerryGeneric5"] = berryXP * 2,
    ["Base.BerryPoisonIvy"] = berryXP * 3,  -- Toxic, extra XP for toxicology
    
    -- Mushrooms (mycology)
    ["Base.MushroomGeneric1"] = mushroomXP * 2,  -- Unknown, more XP
    ["Base.MushroomGeneric2"] = mushroomXP * 2,
    ["Base.MushroomGeneric3"] = mushroomXP * 2,
    ["Base.MushroomGeneric4"] = mushroomXP * 2,
    ["Base.MushroomGeneric5"] = mushroomXP * 2,
    ["Base.MushroomGeneric6"] = mushroomXP * 2,
    ["Base.MushroomGeneric7"] = mushroomXP * 2,
    ["Base.MushroomsButton"] = mushroomXP,
    
    -- Medicinal plants (pharmacology)
    ["Base.BlackSage"] = herbXP,
    ["Base.BlackSageDried"] = herbXP,
    ["Base.CommonMallow"] = herbXP,
    ["Base.CommonMallowDried"] = herbXP,
    ["Base.Comfrey"] = herbXP,
    ["Base.ComfreyDried"] = herbXP,
    ["Base.Ginseng"] = herbXP,
    ["Base.LemonGrass"] = herbXP,
    ["Base.Plantain"] = herbXP,
    ["Base.PlantainDried"] = herbXP,
    ["Base.WildGarlic2"] = herbXP,
    ["Base.WildGarlicDried"] = herbXP,
    
    -- Wild foraged plants (botany)
    ["Base.Acorn"] = plantXP,
    ["Base.Dandelions"] = plantXP,
    ["Base.GrapeLeaves"] = plantXP,
    ["Base.Nettles"] = plantXP,
    ["Base.Rosehips"] = plantXP,
    ["Base.Thistle"] = plantXP,
    ["Base.Violets"] = plantXP,
    
    -- Small animal corpses (anatomy/dissection)
    ["Base.DeadRat"] = smallCorpseXP,
    ["Base.DeadRatBaby"] = smallCorpseXP * 0.75,
    ["Base.DeadMouse"] = smallCorpseXP,
    ["Base.DeadMousePups"] = smallCorpseXP * 0.5,
    ["Base.DeadBird"] = smallCorpseXP,
    ["Base.DeadSquirrel"] = smallCorpseXP * 1.25,
    
    -- Zoology
    ["Base.Frog"] = 15,
    ["Base.Snail"] = insectXP,
    ["Base.Slug"] = insectXP,
    ["Base.Slug2"] = insectXP,
    
    -- Marine biology
    ["Base.Crayfish"] = seafoodXP,
    ["Base.Mussels"] = seafoodXP,
    ["Base.Oysters"] = seafoodXP,
    ["Base.Seaweed"] = seafoodXP,
    ["Base.Shrimp"] = seafoodXP,
    ["Base.Squid"] = seafoodXP * 1.5,
    
    -- Gems, minerals & geology
    ["Base.Diamond"] = gemXP,
    ["Base.Emerald"] = gemXP,
    ["Base.Ruby"] = gemXP,
    ["Base.Sapphire"] = gemXP,
    ["Base.Amethyst"] = gemXP,
    ["Base.Crystal"] = crystalXP,
    ["Base.Crystal_Large"] = crystalXP * 2,
    ["Base.LargeMeteorite"] = 200,  -- Rare space rock
    
    -- Numismatics
    ["Base.GoldCoin"] = coinXP,
    ["Base.SilverCoin"] = coinXP,
}

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
