require "ZScienceSkill/Data"

ZScienceSkill.Data.add({ literature = {
    -- Science books (full XP)
    ["Base.Book_Science"]         = 35,
    ["Base.Paperback_Science"]    = 30,
    ["Base.Magazine_Science"]     = 15,
    ["Base.Magazine_Science_New"] = 15,
    ["Base.Magazine_Tech"]        = 10,
    ["Base.Magazine_Tech_New"]    = 10,
    -- SciFi books (smaller XP - fiction inspires curiosity)
    ["Base.Book_SciFi"]           =  8,
    ["Base.Paperback_SciFi"]      =  8,
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
    ["Base.BrainTan"]               = { Science = specimenXP, Tailoring = specimenXP },
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


-- Mushrooms (mycology)
local mushroomXP = 15
ZScienceSkill.Data.add({ specimens = {
    ["Base.MushroomsButton"]  = mushroomXP,
    ["Base.MushroomGeneric1"] = mushroomXP * 2,  -- Unknown, more XP
    ["Base.MushroomGeneric2"] = mushroomXP * 2,
    ["Base.MushroomGeneric3"] = mushroomXP * 2,
    ["Base.MushroomGeneric4"] = mushroomXP * 2,
    ["Base.MushroomGeneric5"] = mushroomXP * 2,
    ["Base.MushroomGeneric6"] = mushroomXP * 2,
    ["Base.MushroomGeneric7"] = mushroomXP * 2,
}})


-- Medicinal plants (pharmacology)
local sciXP = 10
local docXP = 10
ZScienceSkill.Data.add({ specimens = {
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


-- pills & other medical stuff
local sciXP = 10
local docXP = 20
ZScienceSkill.Data.add({ specimens = {
    ["Base.Antibiotics"]          = { Science = sciXP, Doctor = docXP },
    ["Base.Pills"]                = { Science = sciXP, Doctor = docXP },
    ["Base.PillsAntiDep"]         = { Science = sciXP, Doctor = docXP },
    ["Base.PillsBeta"]            = { Science = sciXP, Doctor = docXP },
    ["Base.PillsSleepingTablets"] = { Science = sciXP, Doctor = docXP },
    ["Base.PillsVitamins"]        = { Science = sciXP, Doctor = docXP },
    ["Base.Stethoscope"]          = { Science = sciXP, Doctor = docXP },
    ["Base.SutureNeedle"]         = { Science = sciXP, Doctor = docXP },
    ["Base.TongueDepressor"]      = { Science = sciXP/2, Doctor = docXP/2 }, -- make it useful for something
}})


-- Wild foraged plants (botany)
local farmXP = 10
local sciXP = farmXP/2
ZScienceSkill.Data.add({ specimens = {
    ["Base.Acorn"]                 = { Science = sciXP, Farming = farmXP },
    ["Base.Dandelions"]            = { Science = sciXP, Farming = farmXP },
    ["Base.GrapeLeaves"]           = { Science = sciXP, Farming = farmXP },
    ["Base.Nettles"]               = { Science = sciXP, Farming = farmXP },
    ["Base.Rosehips"]              = { Science = sciXP, Farming = farmXP },
    ["Base.Thistle"]               = { Science = sciXP, Farming = farmXP },
    ["Base.Violets"]               = { Science = sciXP, Farming = farmXP },

    -- seeds
    ["Base.BarleySeed"]            = { Science = sciXP, Farming = farmXP },
    ["Base.BasilSeed"]             = { Science = sciXP, Farming = farmXP },
    ["Base.BellPepperSeed"]        = { Science = sciXP, Farming = farmXP },
    ["Base.BlackSageSeed"]         = { Science = sciXP, Farming = farmXP },
    ["Base.BroadleafPlantainSeed"] = { Science = sciXP, Farming = farmXP },
    ["Base.BroccoliSeed"]          = { Science = sciXP, Farming = farmXP },
    ["Base.CabbageSeed"]           = { Science = sciXP, Farming = farmXP },
    ["Base.CarrotSeed"]            = { Science = sciXP, Farming = farmXP },
    ["Base.CauliflowerSeed"]       = { Science = sciXP, Farming = farmXP },
    ["Base.ChamomileSeed"]         = { Science = sciXP, Farming = farmXP },
    ["Base.ChivesSeed"]            = { Science = sciXP, Farming = farmXP },
    ["Base.CilantroSeed"]          = { Science = sciXP, Farming = farmXP },
    ["Base.ComfreySeed"]           = { Science = sciXP, Farming = farmXP },
    ["Base.CommonMallowSeed"]      = { Science = sciXP, Farming = farmXP },
    ["Base.CornSeed"]              = { Science = sciXP, Farming = farmXP },
    ["Base.CucumberSeed"]          = { Science = sciXP, Farming = farmXP },
    ["Base.FlaxSeed"]              = { Science = sciXP, Farming = farmXP },
    ["Base.GarlicSeed"]            = { Science = sciXP, Farming = farmXP },
    ["Base.GreenpeasSeed"]         = { Science = sciXP, Farming = farmXP },
    ["Base.HabaneroSeed"]          = { Science = sciXP, Farming = farmXP },
    ["Base.HempSeed"]              = { Science = sciXP, Farming = farmXP },
    ["Base.HopsSeed"]              = { Science = sciXP, Farming = farmXP },
    ["Base.JalapenoSeed"]          = { Science = sciXP, Farming = farmXP },
    ["Base.KaleSeed"]              = { Science = sciXP, Farming = farmXP },
    ["Base.LavenderSeed"]          = { Science = sciXP, Farming = farmXP },
    ["Base.LeekSeed"]              = { Science = sciXP, Farming = farmXP },
    ["Base.LemonGrassSeed"]        = { Science = sciXP, Farming = farmXP },
    ["Base.LettuceSeed"]           = { Science = sciXP, Farming = farmXP },
    ["Base.MarigoldSeed"]          = { Science = sciXP, Farming = farmXP },
    ["Base.MintSeed"]              = { Science = sciXP, Farming = farmXP },
    ["Base.OnionSeed"]             = { Science = sciXP, Farming = farmXP },
    ["Base.OreganoSeed"]           = { Science = sciXP, Farming = farmXP },
    ["Base.ParsleySeed"]           = { Science = sciXP, Farming = farmXP },
    ["Base.PoppySeed"]             = { Science = sciXP, Farming = farmXP },
    ["Base.PotatoSeed"]            = { Science = sciXP, Farming = farmXP },
    ["Base.PumpkinSeed"]           = { Science = sciXP, Farming = farmXP },
    ["Base.RedRadishSeed"]         = { Science = sciXP, Farming = farmXP },
    ["Base.RosemarySeed"]          = { Science = sciXP, Farming = farmXP },
    ["Base.RoseSeed"]              = { Science = sciXP, Farming = farmXP },
    ["Base.RyeSeed"]               = { Science = sciXP, Farming = farmXP },
    ["Base.SageSeed"]              = { Science = sciXP, Farming = farmXP },
    ["Base.SoybeansSeed"]          = { Science = sciXP, Farming = farmXP },
    ["Base.SpinachSeed"]           = { Science = sciXP, Farming = farmXP },
    ["Base.StrewberrieSeed"]       = { Science = sciXP, Farming = farmXP },
    ["Base.SugarBeetSeed"]         = { Science = sciXP, Farming = farmXP },
    ["Base.SweetPotatoSeed"]       = { Science = sciXP, Farming = farmXP },
    ["Base.ThymeSeed"]             = { Science = sciXP, Farming = farmXP },
    ["Base.TobaccoSeed"]           = { Science = sciXP, Farming = farmXP },
    ["Base.TomatoSeed"]            = { Science = sciXP, Farming = farmXP },
    ["Base.TurnipSeed"]            = { Science = sciXP, Farming = farmXP },
    ["Base.WatermelonSeed"]        = { Science = sciXP, Farming = farmXP },
    ["Base.WheatSeed"]             = { Science = sciXP, Farming = farmXP },
    ["Base.WildGarlicSeed"]        = { Science = sciXP, Farming = farmXP },
    ["Base.ZucchiniSeed"]          = { Science = sciXP, Farming = farmXP },
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


-- Chemistry / household chemicals
ZScienceSkill.Data.add({ specimens = {
    ["Base.BakingSoda"]      = { Science = 20, Cooking = 20 },  -- sodium bicarbonate
    ["Base.Hairspray2"]      = 10,                              -- TODO: learn recipe?
    ["Base.InsectRepellent"] = 20,
    ["Base.Vinegar2"]        = { Science = 20, Cooking = 20, key = "Base.Vinegar" },
    ["Base.Vinegar_Jug"]     = { Science = 20, Cooking = 20, key = "Base.Vinegar" },
    ["Base.Yeast"]           = { Science = 10, Cooking = 10 },
}})


-- Industrial / gas equipment
ZScienceSkill.Data.add({ specimens = {
    ["Base.BlowTorch"]      = { Science =  5, MetalWelding = 10 },
    ["Base.Extinguisher"]   =  5,
    ["Base.LighterFluid"]   =  5, -- TODO: make bomb?
    ["Base.Oxygen_Tank"]    = 25,
    ["Base.Propane_Refill"] = 20,
    ["Base.PropaneTank"]    = { Science = 30, MetalWelding = 30 },
}})


-- fluids don't have "Base." prefix nor getFullType() method
ZScienceSkill.Data.add({ fluids = {
    ["Acid"]            = { Science =  50 },
    ["Bleach"]          = { Science =  30 },
    ["Blood"]           = { Science =  50, Doctor = 50 },
    ["Cologne"]         = { Science =  10 }, -- TODO: learn recipeL disinfect rags with cologne
    ["IndustrialDye"]   = { Science =  10, Maintenance = 10 },
    ["SecretFlavoring"] = { Science = 200, Cooking = 50 },
}})


-- Electronics / tech components
ZScienceSkill.Data.add({ specimens = {
    ["Base.Disc_Retail"]       = { Science =  5, Electricity =  5 },
    ["Base.Earbuds"]           = { Science =  5, Electricity =  5 },
    ["Base.ElectricWire"]      = { Science =  5, Electricity =  5 },
    ["Base.HairDryer"]         = { Science =  5, Electricity =  5 },
    ["Base.Headphones"]        = { Science =  5, Electricity =  5 },
    ["Base.LightBulb"]         = { Science =  5, Electricity =  5 },
    ["Base.PowerBar"]          = { Science =  5, Electricity =  5 },

    ["Base.Battery"]           = { Science = 10, Electricity = 10 },
    ["Base.Bullhorn"]          = { Science = 10, Electricity = 10 }, -- megaphone
    ["Base.CarBattery1"]       = { Science = 10, Electricity = 10 },
    ["Base.CarBattery2"]       = { Science = 10, Electricity = 10 },
    ["Base.CarBattery3"]       = { Science = 10, Electricity = 10 },
    ["Base.CordlessPhone"]     = { Science = 10, Electricity = 10 },
    ["Base.ElectronicsScrap"]  = { Science = 10, Electricity = 10 },
    ["Base.Microphone"]        = { Science = 10, Electricity = 10 },
    ["Base.Remote"]            = { Science = 10, Electricity = 10 },
    ["Base.Speaker"]           = { Science = 10, Electricity = 10 },

    ["Base.VideoGame"]         = { Science = 10, Electricity = 15 },

    ["Base.Amplifier"]         = { Science = 20, Electricity = 20 },
    ["Base.CarBatteryCharger"] = { Science = 20, Electricity = 20 },
    ["Base.CDplayer"]          = { Science = 20, Electricity = 20 },
    ["Base.TriggerCrafted"]    = { Science = 20, Electricity = 20 }, -- TODO: learn recipe?
    ["Base.HomeAlarm"]         = { Science = 20, Electricity = 20 },
    ["Base.MotionSensor"]      = { Science = 20, Electricity = 20 },
    ["Base.RadioRed"]          = { Science = 20, Electricity = 20 },
    ["Base.RadioReceiver"]     = { Science = 20, Electricity = 20 },
    ["Base.RadioTransmitter"]  = { Science = 20, Electricity = 20 },
    ["Base.Receiver"]          = { Science = 20, Electricity = 20 }, -- seems like there are both Receiver and RadioReceiver
    ["Base.RemoteCraftedV1"]   = { Science = 10, Electricity = 10 },
    ["Base.RemoteCraftedV2"]   = { Science = 15, Electricity = 15 },
    ["Base.RemoteCraftedV3"]   = { Science = 20, Electricity = 20 },
    ["Base.ScannerModule"]     = { Science = 20, Electricity = 20 },

    ["Base.WalkieTalkie1"]     = { Science = 20, Electricity = 20, key = "Base.WalkieTalkie" },
    ["Base.WalkieTalkie2"]     = { Science = 20, Electricity = 20, key = "Base.WalkieTalkie" },
    ["Base.WalkieTalkie3"]     = { Science = 20, Electricity = 20, key = "Base.WalkieTalkie" },
    ["Base.WalkieTalkie4"]     = { Science = 20, Electricity = 20, key = "Base.WalkieTalkie" },
    ["Base.WalkieTalkie5"]     = { Science = 20, Electricity = 20, key = "Base.WalkieTalkie" },
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
    Steel    = { "MetalBar", "SteelBar", "SteelBarHalf", "SteelBarQuarter", "SteelBlock", "SteelChunk", "SteelIngot", "SteelPiece", "SteelScrap", "SteelSlug" },
    Tin      = { "TinCanEmpty" },
}
for metal, variants in pairs(metals) do
    local metalKey = "Base." .. metal
    for _, variant in ipairs(variants) do
        ZScienceSkill.Data.add({ specimens = {
            ["Base." .. variant] = { Science = sciXP, Blacksmith = blkXP, key = metalKey },
        }})
    end
end


-- Glassmaking
ZScienceSkill.Data.add({ specimens = {
    ["Base.BrokenGlass"]             = { Science = 10, Glassmaking = 20 }, -- TODO: learn recipe
    ["Base.GlassBlowingPipe"]        = { Science = 10, Glassmaking = 20 },
    ["Base.GlassBlowingPipeUnfired"] = { Science = 10, Glassmaking = 20, key = "Base.GlassBlowingPipe" },
    ["Base.Glasses_3dGlasses"]       = { Science =  5, Glassmaking = 10 },
    ["Base.Glasses_Normal"]          = { Science =  5, Glassmaking = 10 }, -- Prescription Glasses renamed in 42.14 ?
    ["Base.Glasses_Prescription"]    = { Science =  5, Glassmaking = 10 },
    ["Base.Loupe"]                   = { Science = 10, Glassmaking = 10 },
    ["Base.MagnifyingGlass"]         = { Science = 15, Glassmaking = 15 },
    ["Base.Glasses_MonocleLeft"]     = { Science =  5, Glassmaking =  5 },
    ["Base.Glasses_MonocleRight"]    = { Science =  5, Glassmaking =  5 },
    ["Base.Glasses_Reading"]         = { Science =  5, Glassmaking =  5 },
}})


-- maintenance stuff
ZScienceSkill.Data.add({ specimens = {
    ["Base.Epoxy"]          = { Science = 10, Maintenance = 15 },
    ["Base.FiberglassTape"] = { Science = 10, Maintenance = 15 },
    ["Base.SteelWool"]      = { Science =  5, Maintenance = 10 },
    ["Base.Whetstone"]      = { Science =  5, Maintenance = 10 },
}})


-- Mechanics
ZScienceSkill.Data.add({ specimens = {
    ["Base.Doorknob"]       = { Mechanics =  1, Woodwork = 5 },
    ["Base.Hinge"]          = { Mechanics =  5, Woodwork = 5 },
    ["Base.LargeHook"]      = { Mechanics =  5 },
    ["Base.Padlock"]        = { Mechanics = 10, Science =  5 },
    ["Base.Pliers"]         = { Mechanics = 10, Science =  5 },
    ["Base.Ratchet"]        = { Mechanics = 15, Science =  5 },
    ["Base.ViseGrips"]      = { Mechanics =  5, Blacksmith = 5 },
    ["Base.Wrench"]         = { Mechanics = 10, Science =  5 },

    ["Base.WristWatch_Left_ClassicBrown"]  = { Mechanics = 5, Science = 5, key = "Base.WristWatch" },
    ["Base.WristWatch_Right_ClassicBrown"] = { Mechanics = 5, Science = 5, key = "Base.WristWatch" },
}})


-- Trapping
ZScienceSkill.Data.add({ specimens = {
    ["Base.RatPoison"]      = { Science =  5, Trapping =  5 }, -- recipes?
    ["Base.TrapMouse"]      = { Science =  5, Trapping = 10 },
}})


-- science stuff
ZScienceSkill.Data.add({ specimens = {
    ["Base.Calipers"]        = { Science = 20, Mechanics = 20 },
    ["Base.CompassGeometry"] = { Science = 20 },
}})


-- Masonry
ZScienceSkill.Data.add({ specimens = {
    ["Base.Clay"]            = { Science = 5, Masonry = 15 },
}})


-- Firearms
ZScienceSkill.Data.add({ specimens = {
    ["Base.ChokeTubeFull"]   = { Science = 5, Aiming = 10 },
}})


-- lulz: random perk)
pcall(function( )
    if Perks.fromIndex and Perks.getMaxIndex then
        local randomPerk = Perks.fromIndex(ZombRand(1, Perks.getMaxIndex()))
        if randomPerk and randomPerk.getId and randomPerk:getId() then
            local tbl = { Science = 10 }
            tbl[randomPerk:getId()] = 200

            ZScienceSkill.Data.add({ specimens = {
                ["Base.EyeOfCthulhu"] = tbl,
            }})
        end
    end
end)
