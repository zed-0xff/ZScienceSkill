require "ZBSpec"

-- assumes sandbox vars:
--   DayNightCycle = 2       -- Endless Day

if isClient() then
    SendCommandToServer("/lua getSandboxOptions():getOptionByName(\"MinutesPerPage\"):setValue(0.001)")
else
    getSandboxOptions():getOptionByName("MinutesPerPage"):setValue(0.001)
end

local function add_inventory_item(player, itemFullType)
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
    player:setTimedActionInstantCheat(false) -- true breaks skillbooks reading in SP
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

