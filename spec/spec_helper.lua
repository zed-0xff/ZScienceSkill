require "ZBSpec"

local function set_sandbox_option(option, value)
    if isClient() then
        SendCommandToServer("/lua getSandboxOptions():getOptionByName(\"" .. option .. "\"):setValue(" .. tostring(value) .. ")")
    else
        getSandboxOptions():getOptionByName(option):setValue(value)
    end
end

local function get_player()
    if isServer() then
        return getOnlinePlayers():get(0) -- XXX assumes only one player online
    else
        return getPlayer()
    end
end

set_sandbox_option("DayNightCycle", 2) -- Endless Day

local function set_timed_action_instant_cheat(value)
    if isClient() then
        SendCommandToServer("/lua getOnlinePlayers():get(0):setTimedActionInstantCheat(" .. tostring(value) .. ")")
    else
        getPlayer():setTimedActionInstantCheat(value)
    end
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
    assert.is_not_nil(item, "Failed to create item: " .. itemFullType)
    return item
end

local function init_player(player)
    if isClient() then
        -- XXX assumes only one player online
        SendCommandToServer("/lua getOnlinePlayers():get(0):getInventory():clear()")
        SendCommandToServer("/lua getOnlinePlayers():get(0):getReadLiterature():clear()")
    end
    -- both for SP and MP client
    player:getInventory():clear()
    player:getReadLiterature():clear()
end

local function read_book(player, book)
    ISTimedActionQueue.add(ISReadABook:new(player, book, 1))
    wait_for_not(ISTimedActionQueue.isPlayerDoingAction, player)
end

-- for skillbooks
local function reset_pages(player, book)
    if isClient() then
        SendCommandToServer("/lua getOnlinePlayers():get(0):setAlreadyReadPages(\"" .. book:getFullType() .. "\", 0)")
    end
    player:setAlreadyReadPages(book:getFullType(), 0)
end

