describe("addXp for Science perk", function()
    local player = get_player()
    
    before_each(function()
        init_player(player)
    end)
    
    it("works without error", function()
        local xpBefore = player:getXp():getXP(Perks.Science)
        
        -- This should not throw NullPointerException
        addXp(player, Perks.Science, 50)
        
        wait_for(function()
            return player:getXp():getXP(Perks.Science) > xpBefore
        end)
    end)
end)

return ZBSpec.runAsync()
