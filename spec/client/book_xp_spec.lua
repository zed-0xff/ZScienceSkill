require "ZBSpec"

-- assumes sandbox vars:
--   DayNightCycle = 2       -- Endless Day
--   MinutesPerPage = 0.01   -- very fast reading

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
end

local function read_book(player, book)
    ISTimedActionQueue.add(ISReadABook:new(player, book, 1))
    wait_for_not(ISTimedActionQueue.isPlayerDoingAction, player)
end

-- Integration tests require player
ZBSpec.player.describe("ISReadABook hook", function()
    local player = getPlayer()
    local ITEMTYPE_BOOK_SCIENCE = "Base.Book_Science"

    before_each(function()
        player:setTimedActionInstantCheat(true)
        init_player(player)
    end)
    
    it("grants Science XP when reading science book", function()
        local book = add_inventory_item(player, ITEMTYPE_BOOK_SCIENCE)
        local xpBefore = player:getXp():getXP(Perks.Science)

        read_book(player, book)
        wait_for(function()
            return player:getXp():getXP(Perks.Science) > xpBefore
        end)
    end)
    
    it("grants more XP for science book than scifi book", function()
        -- Read science book
        local sciBook = add_inventory_item(player, ITEMTYPE_BOOK_SCIENCE)
        local xpBefore1 = player:getXp():getXP(Perks.Science)

        read_book(player, sciBook)
        wait_for(function()
            return player:getXp():getXP(Perks.Science) > xpBefore1
        end)

        -- Read scifi book
        local sciFiBook = add_inventory_item(player, "Base.Book_SciFi")
        local xpBefore2 = player:getXp():getXP(Perks.Science)

        read_book(player, sciFiBook)
        wait_for(function()
            return player:getXp():getXP(Perks.Science) > xpBefore2
        end)

        local scienceXP = xpBefore2 - xpBefore1
        local scifiXP   = player:getXp():getXP(Perks.Science) - xpBefore2

        assert.greater_than(scifiXP, scienceXP)
    end)
    
    it("does not grant infinite XP", function()
        local book = add_inventory_item(player, ITEMTYPE_BOOK_SCIENCE)
        local xpBefore = player:getXp():getXP(Perks.Science)

        read_book(player, book) -- first time, grants XP
        wait_for(function()
            return player:getXp():getXP(Perks.Science) > xpBefore
        end)

        xpBefore = player:getXp():getXP(Perks.Science)
        for i = 1, 5 do
            read_book(player, book) -- same book again
            assert.equals(xpBefore, player:getXp():getXP(Perks.Science)) -- no xp
        end
    end)
end)

return ZBSpec.runAsync()
