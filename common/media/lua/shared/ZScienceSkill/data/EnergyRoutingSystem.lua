require "ZScienceSkill/Data"

ZScienceSkill.Data.add({ specimens = {
    ["EnergyRouting.SolarPanel"]           = { Science = 20, Electricity = 20 },
    ["EnergyRouting.SolarPanelHorizontal"] = { Science = 20, Electricity = 20, key = "EnergyRouting.SolarPanel" },
    ["EnergyRouting.TurbinaHidraulica"]    = { Science = 20, Electricity = 20 },
    ["EnergyRouting.TurbineHelice"]        = { Science = 10, Electricity = 10, Mechanics = 10 },
    ["EnergyRouting.WindTurbineMotor"]     = { Science = 20, Electricity = 20 },
    ["EnergyRouting.WireTransferEnergy"]   = { Science = 10, Electricity = 10 },
}})
