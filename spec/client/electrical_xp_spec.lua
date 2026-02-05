-- Test for ZScienceSkill_ElectricalXP.lua
-- Verifies Science XP is granted when gaining Electrical XP

local function dismantle_radio(player, item)
    local recipe = getScriptManager():getCraftRecipe("DismantleRadio")
    local playerNum = player:getPlayerNum()

    ISInventoryPaneContextMenu.OnNewCraft(item, recipe, playerNum, false)
    wait_for_not(ISTimedActionQueue.isPlayerDoingAction, player)
end

ZBSpec.describe("Electrical XP synergy", function()
    local player = getPlayer()

    before_all(function()
        set_timed_action_instant_cheat(true)
        add_item(player, "Base.Screwdriver")
        -- TODO: find reliable way to get more Electircal XP in test and remove ZScienceSkill.minGain
        if isClient() then
            SendCommandToServer("/lua ZScienceSkill.minGain=0")
        else
            ZScienceSkill.minGain = 0
        end
    end)
    
    it("grants Science XP when gaining Electrical XP", function()
        local scienceBefore = player:getXp():getXP(Perks.Science)
        local electricalBefore = player:getXp():getXP(Perks.Electricity)

        local radio = add_item(player, "Base.RadioBlack")
        dismantle_radio(player, radio) -- Should gain some Science XP (50% of Electrical)
        wait_for(function()
            return player:getXp():getXP(Perks.Electricity) > electricalBefore
        end)
        
        local scienceAfter = player:getXp():getXP(Perks.Science)
        assert.greater_than(scienceBefore, scienceAfter)
    end)
end)

return ZBSpec.runAsync()
