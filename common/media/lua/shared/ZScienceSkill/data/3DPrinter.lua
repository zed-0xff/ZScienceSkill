-- 3DPrinter mod integration
require "ZScienceSkill/Data"

local filamentXP = 10
ZScienceSkill.Data.add({
    specimens = {
        -- Filaments (polymer science / materials science)
        ["Printer3D.Filament3D_Blue"] = filamentXP,
        ["Printer3D.Filament_Green"]  = filamentXP,
        ["Printer3D.Filament_Yellow"] = filamentXP,
        ["Printer3D.Filament_Orange"] = filamentXP,
        ["Printer3D.Filament_Violet"] = filamentXP,
        ["Printer3D.Filament_Brown"]  = filamentXP,
    },
    literatureReadOnce = {
        -- Design blueprints (technical documentation)
        ["Printer3D.Design_Basics"]     = 20, -- 14 pages
        ["Printer3D.Design_Industrial"] = 35, -- 28 pages
        ["Printer3D.Design_Heavy"]      = 50, -- 42 pages
        ["Printer3D.Design_Advanced"]   = 70, -- 64 pages
        ["Printer3D.Design_Reclicler"]  = 70, -- 64 pages, recycler blueprints
    },
})
