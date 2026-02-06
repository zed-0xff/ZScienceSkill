-- Client-side command handler for ZScienceSkill
-- Handles UI feedback triggered by server

local MODULE = "ZScienceSkill"

Events.OnServerCommand.Add(function(module, command, args)
    if module ~= MODULE then return end
    
    local player = getPlayer()
    if not player then return end
    
    if command == "herbalistUnlocked" then
        player:playSound("GainExperienceLevel")
        HaloTextHelper.addTextWithArrow(player, getText("IGUI_HerbalistUnlocked"), true, HaloTextHelper.getColorGreen())
    elseif command == "herbalistProgress" then
        local count = args.count or 0
        if count <= 3 then
            player:Say(getText("IGUI_HerbalistHint1"))
        elseif count <= 5 then
            player:Say(getText("IGUI_HerbalistHint2"))
        elseif count <= 9 then
            player:Say(getText("IGUI_HerbalistHint3"))
        end
    end
end)
