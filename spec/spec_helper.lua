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

---------------------------------------------

local function set_sandbox_option(option, value)
    all_exec("getSandboxOptions():getOptionByName(\"" .. option .. "\"):setValue(" .. tostring(value) .. ")")
end

set_sandbox_option("DayNightCycle", 2) -- Endless Day

local function set_timed_action_instant(value)
    all_exec("(getPlayer() or getOnlinePlayers():get(0)):setTimedActionInstantCheat(" .. tostring(value) .. ")")
end

local function add_item(player, itemFullType)
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

local function read_book(player, book)
    ISTimedActionQueue.add(ISReadABook:new(player, book, 1))
    wait_for_not(ISTimedActionQueue.isPlayerDoingAction, player)
end

-- for skillbooks
local function reset_pages(player, book)
    if isClient() then
        server_exec("getOnlinePlayers():get(0):setAlreadyReadPages(\"" .. book:getFullType() .. "\", 0)")
    end
    player:setAlreadyReadPages(book:getFullType(), 0)
end

local function set_perk_level(player, perk, level)
    if isClient() then
        server_exec("getOnlinePlayers():get(0):setPerkLevelDebug(Perks." .. tostring(perk) .. ", " .. level .. ")")
    else
        player:setPerkLevelDebug(perk, level)
    end
end

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
    local sprite = IsoSprite.new()
    sprite:LoadFramesNoDirPageSimple("location_community_medical_01_139")
    local obj = IsoObject.new(getCell(), sq, sprite)
    obj:getProperties():Set("CustomName", "Microscope")
    sq:AddTileObject(obj)
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
    player:getModData().researchedSpecimens = {}
    player:getModData().researchedPlants = {}
    if isClient() then
        server_exec("getOnlinePlayers():get(0):getModData().researchedSpecimens = {}")
        server_exec("getOnlinePlayers():get(0):getModData().researchedPlants = {}")
    end
end

---------------------------------------------
-- Export globals for use in specs
---------------------------------------------
_G.set_sandbox_option = set_sandbox_option
_G.set_timed_action_instant = set_timed_action_instant
_G.add_item = add_item
_G.read_book = read_book
_G.reset_pages = reset_pages
_G.set_perk_level = set_perk_level
_G.place_microscope = place_microscope
_G.remove_microscope = remove_microscope
_G.research_specimen = research_specimen
_G.clear_research_data = clear_research_data

