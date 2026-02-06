-- Client-side integration tests for ISResearchSpecimen
-- Tests the full research flow with player actions

-- Place a microscope on the player's square (for testing research)
local function place_microscope(player)
    local sq = player:getSquare()
    if not sq then return nil end
    
    -- Check if microscope already exists on square
    for i = 0, sq:getObjects():size() - 1 do
        local obj = sq:getObjects():get(i)
        if obj and obj.getProperties and obj:getProperties():get("CustomName") == "Microscope" then
            return obj -- Already have one
        end
    end
    
    -- Create and add microscope
    sq:addTileObject("location_community_medical_01_139")
    return obj
end

-- Remove microscope from player's square
local function remove_microscope(player)
    local sq = player:getSquare()
    if not sq then return end
    
    for i = sq:getObjects():size() - 1, 0, -1 do
        local obj = sq:getObjects():get(i)
        if obj and obj.getProperties and obj:getProperties():get("CustomName") == "Microscope" then
            sq:RemoveTileObject(obj)
            return
        end
    end
end

-- Perform research on a specimen
local function research_specimen(player, item)
    ISTimedActionQueue.add(ISResearchSpecimen:new(player, item, 100))
    wait_for_not(ISTimedActionQueue.isPlayerDoingAction, player)
end

-- Clear player's research data
local function clear_research_data(player)
    all_exec("(getPlayer() or getOnlinePlayers():get(0)):getModData().researchedSpecimens = {}")
    all_exec("(getPlayer() or getOnlinePlayers():get(0)):getModData().researchedPlants = {}")
    all_exec("(getPlayer() or getOnlinePlayers():get(0)):getXp():AddXP(Perks.Science, -999)")
end

ZBSpec.describe("ISResearchSpecimen action", function()
    local player = get_player()
    
    before_all(function()
        set_timed_action_instant(true)
        place_microscope(player)
    end)
    
    before_each(function()
        clear_research_data(player)
        init_player(player)
        SyncXp(player)
    end)
    
    describe("researching a specimen", function()
        it("grants Science XP for Cricket", function()
            local specimen = add_item(player, "Base.Cricket")
            local xpBefore = player:getXp():getXP(Perks.Science)
            
            print("XP before research: " .. xpBefore)
            research_specimen(player, specimen)
            
            wait_for(function()
                return player:getXp():getXP(Perks.Science) > xpBefore
            end)
        end)
        
        it("marks specimen as researched in ModData", function()
            local specimen = add_item(player, "Base.Cricket")
            
            assert.is_false(ISResearchSpecimen.isResearched(player, specimen))
            
            research_specimen(player, specimen)
            
            wait_for(ISResearchSpecimen.isResearched, player, specimen)
        end)
        
        it("cannot research same specimen twice", function()
            local specimen = add_item(player, "Base.Cricket")
            local xpBefore = player:getXp():getXP(Perks.Science)
            
            research_specimen(player, specimen)
            wait_for(function()
                return player:getXp():getXP(Perks.Science) > xpBefore
            end)
            
            -- Get XP after first research
            local xpAfterFirst = player:getXp():getXP(Perks.Science)
            
            -- Add another cricket and try to research
            local specimen2 = add_item(player, "Base.Cricket")
            research_specimen(player, specimen2)
            
            -- XP should not increase (already researched this type)
            assert.equals(xpAfterFirst, player:getXp():getXP(Perks.Science))
        end)
    end)
    
    describe("researching dung specimens", function()
        it("grants Tracking XP for dung", function()
            local dung = add_item(player, "Base.Dung_Deer")
            local trackingBefore = player:getXp():getXP(Perks.Tracking)
            
            research_specimen(player, dung)
            
            wait_for(function()
                return player:getXp():getXP(Perks.Tracking) > trackingBefore
            end)
        end)
    end)
    
    describe("researching pills", function()
        it("grants Doctor XP for pills", function()
            local pills = add_item(player, "Base.PillsAntiDep")
            local doctorBefore = player:getXp():getXP(Perks.Doctor)
            
            research_specimen(player, pills)
            
            wait_for(function()
                return player:getXp():getXP(Perks.Doctor) > doctorBefore
            end)
        end)
    end)
end)

return ZBSpec.runAsync()
