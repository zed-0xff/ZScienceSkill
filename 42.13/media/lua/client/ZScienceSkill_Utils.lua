ZScienceSkill = ZScienceSkill or {}

-- Get fluid type string from item if it has a fluid container
function ZScienceSkill.getFluidType(item)
    local fc = item:getFluidContainer()
    if fc and fc:getPrimaryFluid() then
        return fc:getPrimaryFluid():getFluidTypeString()
    end
    return nil
end
