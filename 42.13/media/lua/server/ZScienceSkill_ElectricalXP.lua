-- Grant Science XP when gaining Electrical XP
if isClient() then return end

local function onAddXP(character, perk, amount)
    print("onAddXP called: perk=" .. tostring(perk) .. ", amount=" .. tostring(amount))
    if perk == Perks.Electricity and amount > 0 then
        local scienceXP = math.floor(amount * 0.5)
        if scienceXP > 0 then
            character:getXp():AddXP(Perks.Science, scienceXP)
        end
    end
end

Events.AddXP.Add(onAddXP)
