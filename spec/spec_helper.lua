-- Spec helper functions for ZScienceSkill tests
-- Functions declared without 'local' so they're written to the request-scoped
-- shared environment (not _G). This allows spec files to access them without
-- polluting the global namespace.

require "ZBSpec"

function get_player()
    if isServer() then
        return getOnlinePlayers():get(0) -- XXX assumes only one player online
    else
        return getPlayer()
    end
end

function init_player(player)
    if not player then
        player = get_player()
    end
    -- Abort any action the player is currently doing
    if ISTimedActionQueue and ISTimedActionQueue.clear then
        ISTimedActionQueue.clear(get_player())
    end
    if isClient() then
        -- Use server_eval (not server_exec) to wait for server to complete clearing
        -- before test continues. Otherwise race condition: add_item might run before
        -- server processes the clear, causing items to disappear after being added.
        server_eval("getOnlinePlayers():get(0):getInventory():clear()")
        server_eval("getOnlinePlayers():get(0):getReadLiterature():clear()")
    end
    -- both for SP and MP client
    player:getInventory():clear()
    player:getReadLiterature():clear()
end

-- abort any action the player is currently doing (e.g. reading a book)
if ISTimedActionQueue and ISTimedActionQueue.clear then
    ISTimedActionQueue.clear(get_player())
end

---------------------------------------------

function set_sandbox_option(option, value)
    all_exec("getSandboxOptions():getOptionByName(\"" .. option .. "\"):setValue(" .. tostring(value) .. ")")
end

set_sandbox_option("DayNightCycle", 2) -- Endless Day

function set_timed_action_instant(value)
    -- Can't use get_player() here - all_exec sends code as string to server
    -- where spec_helper functions aren't available
    all_exec("(getPlayer() or getOnlinePlayers():get(0)):setTimedActionInstantCheat(" .. tostring(value) .. ")")
end

function add_item(player, itemFullType)
    local item = nil
    if isClient() then
        -- MP
        SendCommandToServer("/additem \"" .. player:getDisplayName() .. "\" \"" .. itemFullType .. "\"")
        local inv = player:getInventory()
        wait_for(inv.contains, inv, itemFullType)
        item = inv:getItemFromType(itemFullType, false, false)
    else
        -- SP
        item = instanceItem(itemFullType)
        player:getInventory():AddItem(item)
    end
    assert(item, "Failed to create item: " .. itemFullType)
    return item
end

function read_book(player, book)
    ISTimedActionQueue.add(ISReadABook:new(player, book, 1))
    wait_for_not(ISTimedActionQueue.isPlayerDoingAction, player)
end

-- for skillbooks
function reset_pages(player, book)
    all_exec("(getPlayer() or getOnlinePlayers():get(0)):setAlreadyReadPages(\"" .. book:getFullType() .. "\", 0)")
end

function set_perk_level(player, perk, level)
    all_exec("(getPlayer() or getOnlinePlayers():get(0)):setPerkLevelDebug(Perks." .. tostring(perk) .. ", " .. level .. ")")
end

-- Place a microscope on the player's square (for testing research)
function place_microscope(player)
    local sq = player:getSquare()
    if not sq then return nil end
    
    -- Check if microscope already exists on square
    for i = 0, sq:getObjects():size() - 1 do
        local obj = sq:getObjects():get(i)
        if obj and obj.getProperties and obj:getProperties():get("CustomName") == "Microscope" then
            return obj
        end
    end
    
    return sq:addTileObject("location_community_medical_01_139")
end

-- Remove microscope from player's square
function remove_microscope(player)
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
function research_specimen(player, item)
    ISTimedActionQueue.add(ISResearchSpecimen:new(player, item, 100))
    wait_for_not(ISTimedActionQueue.isPlayerDoingAction, player)
end

-- Clear player's research data
function clear_research_data(player)
    all_exec("(getPlayer() or getOnlinePlayers():get(0)):getModData().researchedSpecimens = nil")
    all_exec("(getPlayer() or getOnlinePlayers():get(0)):getModData().researchedPlants = nil")
end
