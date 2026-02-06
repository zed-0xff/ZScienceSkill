ZScienceSkill = ZScienceSkill or {}

-- Get fluid type string from item if it has a fluid container
function ZScienceSkill.getFluidType(item)
    local fc = item:getFluidContainer()
    if fc and fc:getPrimaryFluid() then
        return fc:getPrimaryFluid():getFluidTypeString()
    end
    return nil
end

function ZScienceSkill.isCombatPerk(perk)
    local perkObj = PerkFactory.getPerk(perk)
    if not perkObj then return false end
    
    local parent = perkObj:getParent()
    return parent == Perks.Combat or parent == Perks.Firearm
           or perk == Perks.Combat or perk == Perks.Firearm
end
