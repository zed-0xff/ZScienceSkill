-- Test for ZScienceSkill_XPBoost.lua
-- Verifies skill XP boost is applied correctly

local function carve_spear(player, item)
    local recipe = getScriptManager():getCraftRecipe("CarveSpear")
    local playerNum = player:getPlayerNum()

    ISInventoryPaneContextMenu.OnNewCraft(item, recipe, playerNum, false)
    wait_for_not(ISTimedActionQueue.isPlayerDoingAction, player)
end

ZBSpec.describe("XP boost", function()
    local player = get_player()

    before_all(function()
        set_timed_action_instant(true)
        add_item(player, "Base.HuntingKnife")
        all_exec("ZScienceSkill.minGain=0")
    end)
    
    it("increases skill XP gain with higher Science level", function()
        local function make(level)
            set_perk_level(player, Perks.Science, level)

            local xpBefore = player:getXp():getXP(Perks.Carving)
            local stick = add_item(player, "Base.LongStick")
            carve_spear(player, stick)
            wait_for(function()
                return player:getXp():getXP(Perks.Carving) > xpBefore
            end)
            return player:getXp():getXP(Perks.Carving) - xpBefore
        end

        local xp10 = make(10)
        local xp05 = make(5)
        local xp00 = make(0)

        assert(xp05 > xp00)
        assert(xp10 > xp05)
    end)
end)

return ZBSpec.runAsync()
