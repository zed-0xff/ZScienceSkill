require "ZScienceSkill/Data"

ZScienceSkill.Data.add({ literature = {
    -- Science books (full XP)
    ["Base.Book_Science"]         = 35,
    ["Base.Paperback_Science"]    = 30,
    ["Base.Magazine_Science"]     = 15,
    ["Base.Magazine_Science_New"] = 15,
    -- SciFi books (smaller XP - fiction inspires curiosity)
    ["Base.Book_SciFi"]           = 10,
    ["Base.Paperback_SciFi"]      = 10,
}})


local specimenXP = 30
ZScienceSkill.Data.add({ specimens = {
    -- Preserved specimens
    ["Base.Specimen_Insects"]       = specimenXP,
    ["Base.Specimen_Beetles"]       = specimenXP,
    ["Base.Specimen_Butterflies"]   = specimenXP,
    ["Base.Specimen_Centipedes"]    = specimenXP,
    ["Base.Specimen_Tapeworm"]      = specimenXP,
    ["Base.Specimen_Minerals"]      = specimenXP,
    ["Base.Specimen_Octopus"]       = specimenXP,
    ["Base.Specimen_FetalCalf"]     = specimenXP,
    ["Base.Specimen_FetalLamb"]     = specimenXP,
    ["Base.Specimen_FetalPiglet"]   = specimenXP,
    ["Base.Specimen_MonkeyHead"]    = specimenXP,
    ["Base.Specimen_Brain"]         = { Science = specimenXP * 2, Doctor = specimenXP },

    -- Animal brains & skulls
    ["Base.Animal_Brain"]           = specimenXP * 1.5,
    ["Base.Animal_Brain_Small"]     = specimenXP,
    ["Base.AnimalSinew"]            = specimenXP * 0.5,
    ["Base.Hominid_Skull"]          = specimenXP,
    ["Base.Hominid_Skull_Fragment"] = specimenXP * 0.5,
    ["Base.Hominid_Skull_Partial"]  = specimenXP * 0.75,
}})


local insectXP = 10
ZScienceSkill.Data.add({ specimens = {
    -- Insects (entomology)
    ["Base.AmericanLadyCaterpillar"]    = insectXP,
    ["Base.BandedWoolyBearCaterpillar"] = insectXP,
    ["Base.Centipede"]                  = insectXP,
    ["Base.Centipede2"]                 = insectXP,
    ["Base.Cockroach"]                  = insectXP,
    ["Base.Cricket"]                    = insectXP,
    ["Base.Grasshopper"]                = insectXP,
    ["Base.Ladybug"]                    = insectXP,
    ["Base.Leech"]                      = insectXP,
    ["Base.Maggots"]                    = insectXP * 0.5,
    ["Base.Millipede"]                  = insectXP,
    ["Base.Millipede2"]                 = insectXP,
    ["Base.MonarchCaterpillar"]         = insectXP,
    ["Base.Pillbug"]                    = insectXP * 0.5,
    ["Base.SawflyLarva"]                = insectXP,
    ["Base.SilkMothCaterpillar"]        = insectXP,
    ["Base.SwallowtailCaterpillar"]     = insectXP,
    ["Base.Termites"]                   = insectXP,
    ["Base.Worm"]                       = insectXP * 0.5,

    -- Zoology
    ["Base.Frog"]                       = insectXP * 2,
    ["Base.Snail"]                      = insectXP,
    ["Base.Slug"]                       = insectXP,
    ["Base.Slug2"]                      = insectXP,
}})


local berryXP = 10
ZScienceSkill.Data.add({ specimens = {
    -- Berries (botany)
    ["Base.BeautyBerry"]    = berryXP,
    ["Base.HollyBerry"]     = berryXP,
    ["Base.WinterBerry"]    = berryXP,
    ["Base.BerryBlack"]     = berryXP,
    ["Base.BerryBlue"]      = berryXP,
    ["Base.BerryGeneric1"]  = berryXP * 2,  -- Unknown berry, more XP for identification
    ["Base.BerryGeneric2"]  = berryXP * 2,
    ["Base.BerryGeneric3"]  = berryXP * 2,
    ["Base.BerryGeneric4"]  = berryXP * 2,
    ["Base.BerryGeneric5"]  = berryXP * 2,
    ["Base.BerryPoisonIvy"] = berryXP * 3,  -- Toxic, extra XP for toxicology
}})


local mushroomXP = 15
ZScienceSkill.Data.add({ specimens = {
    -- Mushrooms (mycology)
    ["Base.MushroomsButton"]  = mushroomXP,
    ["Base.MushroomGeneric1"] = mushroomXP * 2,  -- Unknown, more XP
    ["Base.MushroomGeneric2"] = mushroomXP * 2,
    ["Base.MushroomGeneric3"] = mushroomXP * 2,
    ["Base.MushroomGeneric4"] = mushroomXP * 2,
    ["Base.MushroomGeneric5"] = mushroomXP * 2,
    ["Base.MushroomGeneric6"] = mushroomXP * 2,
    ["Base.MushroomGeneric7"] = mushroomXP * 2,
}})


local sciXP = 10
local docXP = 10
ZScienceSkill.Data.add({ specimens = {
    -- Medicinal plants (pharmacology)
    ["Base.BlackSage"]         = { Science = sciXP, Doctor = docXP },
    ["Base.BlackSageDried"]    = { Science = sciXP, Doctor = docXP },
    ["Base.CommonMallow"]      = { Science = sciXP, Doctor = docXP },
    ["Base.CommonMallowDried"] = { Science = sciXP, Doctor = docXP },
    ["Base.Comfrey"]           = { Science = sciXP, Doctor = docXP },
    ["Base.ComfreyDried"]      = { Science = sciXP, Doctor = docXP },
    ["Base.Ginseng"]           = { Science = sciXP, Doctor = docXP },
    ["Base.LemonGrass"]        = { Science = sciXP, Doctor = docXP },
    ["Base.Plantain"]          = { Science = sciXP, Doctor = docXP },
    ["Base.PlantainDried"]     = { Science = sciXP, Doctor = docXP },
    ["Base.WildGarlic2"]       = { Science = sciXP, Doctor = docXP },
    ["Base.WildGarlicDried"]   = { Science = sciXP, Doctor = docXP },
}})


local plantXP = 10
ZScienceSkill.Data.add({ specimens = {
    -- Wild foraged plants (botany)
    ["Base.Acorn"]       = plantXP,
    ["Base.Dandelions"]  = plantXP,
    ["Base.GrapeLeaves"] = plantXP,
    ["Base.Nettles"]     = plantXP,
    ["Base.Rosehips"]    = plantXP,
    ["Base.Thistle"]     = plantXP,
    ["Base.Violets"]     = plantXP,
}})


local smallCorpseXP = 15
ZScienceSkill.Data.add({ specimens = {
    -- Small animal corpses (anatomy/dissection)
    ["Base.DeadRat"]       = smallCorpseXP,
    ["Base.DeadRatBaby"]   = smallCorpseXP * 0.75,
    ["Base.DeadMouse"]     = smallCorpseXP,
    ["Base.DeadMousePups"] = smallCorpseXP * 0.5,
    ["Base.DeadBird"]      = smallCorpseXP,
    ["Base.DeadSquirrel"]  = smallCorpseXP * 1.25,
}})


local seafoodXP = 10
ZScienceSkill.Data.add({ specimens = {
    -- Marine biology
    ["Base.Crayfish"] = seafoodXP,
    ["Base.Mussels"]  = seafoodXP,
    ["Base.Oysters"]  = seafoodXP,
    ["Base.Seaweed"]  = seafoodXP,
    ["Base.Shrimp"]   = seafoodXP,
    ["Base.Squid"]    = seafoodXP * 1.5,
}})

local gemXP = 30
ZScienceSkill.Data.add({ specimens = {
    -- Gems, minerals & geology
    ["Base.Diamond"]        = gemXP,
    ["Base.Emerald"]        = gemXP,
    ["Base.Ruby"]           = gemXP,
    ["Base.Sapphire"]       = gemXP,
    ["Base.Amethyst"]       = gemXP,
    ["Base.Crystal"]        = gemXP,
    ["Base.Crystal_Large"]  = gemXP * 1.5,
    ["Base.LargeMeteorite"] = 200,  -- Rare space rock
}})


local sciXP = 10
local traXP = 15
ZScienceSkill.Data.add({ specimens = {
    -- Animal dung (tracking/scat analysis)
    ["Base.Dung_Turkey"]          = { Science = sciXP, Tracking = traXP },
    ["Base.Dung_Chicken"]         = { Science = sciXP, Tracking = traXP },
    ["Base.Dung_Cow"]             = { Science = sciXP, Tracking = traXP },
    ["Base.Dung_Deer"]            = { Science = sciXP, Tracking = traXP },
    ["Base.Dung_Mouse"]           = { Science = sciXP, Tracking = traXP },
    ["Base.Dung_Pig"]             = { Science = sciXP, Tracking = traXP },
    ["Base.Dung_Rabbit"]          = { Science = sciXP, Tracking = traXP },
    ["Base.Dung_Raccoon"]         = { Science = sciXP, Tracking = traXP },
    ["Base.Dung_Rat"]             = { Science = sciXP, Tracking = traXP },
    ["Base.Dung_Sheep"]           = { Science = sciXP, Tracking = traXP },
}})


local sciXP = 15
local docXP = 20
ZScienceSkill.Data.add({ specimens = {
    ["Base.Antibiotics"]          = { Science = sciXP, Doctor = docXP },
    ["Base.Pills"]                = { Science = sciXP, Doctor = docXP },
    ["Base.PillsAntiDep"]         = { Science = sciXP, Doctor = docXP },
    ["Base.PillsBeta"]            = { Science = sciXP, Doctor = docXP },
    ["Base.PillsSleepingTablets"] = { Science = sciXP, Doctor = docXP },
    ["Base.PillsVitamins"]        = { Science = sciXP, Doctor = docXP },
}})

-- Chemistry / household chemicals
ZScienceSkill.Data.add({ specimens = {
    ["Base.BakingSoda"]   = { Science = 20, Cooking = 20 },  -- sodium bicarbonate
    ["Base.Vinegar2"]     = { Science = 20, Cooking = 20, key = "Base.Vinegar" },
    ["Base.Vinegar_Jug"]  = { Science = 20, Cooking = 20, key = "Base.Vinegar" },
}})

-- Industrial / gas equipment
ZScienceSkill.Data.add({ specimens = {
    ["Base.Oxygen_Tank"]    = 25,
    ["Base.Propane_Refill"] = 20,
}})

-- fluids don't have "Base." prefix nor getFullType() method
ZScienceSkill.Data.add({ fluids = {
    ["Acid"]            = { Science =  50 },
    ["Bleach"]          = { Science =  30 },
    ["Blood"]           = { Science =  50,  Doctor = 50 },
    ["SecretFlavoring"] = { Science = 200, Cooking = 50 },
}})


-- metals
local sciXP = 10
local blkXP = 20
local metals = {
    Aluminum = { "Aluminum", "AluminumFragments", "AluminumScrap" },
    Bronze   = { "TrophyBronze", "Medal_Bronze" },
    Copper   = { "CopperOre", "CopperIngot", "CopperSheet", "SmallCopperSheet", "CopperScrap" },
    Gold     = { "GoldBar", "SmallGoldBar", "GoldScrap", "GoldSheet", "GoldCoin", "Medal_Gold", "TrophyGold" },
    Iron     = { "IronBar", "IronBarHalf", "IronBarQuarter", "IronBlock", "IronChunk", "IronIngot", "IronOre", "IronPiece", "IronScrap" },
    Silver   = { "SilverBar", "SmallSilverBar", "SilverScrap", "SilverSheet", "SilverCoin", "TrophySilver", "Medal_Silver" },
    Steel    = { "SteelBar", "SteelBarHalf", "SteelBarQuarter", "SteelBlock", "SteelChunk", "SteelIngot", "SteelPiece", "SteelScrap", "SteelSlug", "SteelWool" },
}
for metal, variants in pairs(metals) do
    local metalKey = "Base." .. metal
    for _, variant in ipairs(variants) do
        ZScienceSkill.Data.add({ specimens = {
            ["Base." .. variant] = { Science = sciXP, Blacksmith = blkXP, key = metalKey },
        }})
    end
end
