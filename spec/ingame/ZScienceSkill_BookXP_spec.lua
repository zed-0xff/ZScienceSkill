-- zbtest: Test for ZScienceSkill_BookXP.lua
-- Tests that reading books grants Science XP

require "ZScienceSkill_Data"

local player = getPlayer()
if not player then
    return "getPlayer() returned nil - player not loaded"
end

local errors = {}

-- Set timed actions to instant for testing
local wasInstant = player:isTimedActionInstantCheat()
player:setTimedActionInstantCheat(true)

-- Test 1: ZScienceSkill.literature table exists and has science book
if not ZScienceSkill or not ZScienceSkill.literature then
    table.insert(errors, "ZScienceSkill.literature table not found")
elseif not ZScienceSkill.literature["Base.Book_Science"] then
    table.insert(errors, "Base.Book_Science not in literature table")
elseif ZScienceSkill.literature["Base.Book_Science"] ~= 35 then
    table.insert(errors, string.format(
        "Base.Book_Science XP: expected 35, got %s", 
        tostring(ZScienceSkill.literature["Base.Book_Science"])
    ))
end

-- Test 2: SciFi books grant less XP than science books
if ZScienceSkill and ZScienceSkill.literature then
    local scienceXP = ZScienceSkill.literature["Base.Book_Science"] or 0
    local scifiXP = ZScienceSkill.literature["Base.Book_SciFi"] or 0
    if scifiXP >= scienceXP then
        table.insert(errors, string.format(
            "SciFi XP (%d) should be less than Science XP (%d)",
            scifiXP, scienceXP
        ))
    end
end

-- Test 3: skillBookXP table exists with correct progression
if not ZScienceSkill or not ZScienceSkill.skillBookXP then
    table.insert(errors, "ZScienceSkill.skillBookXP table not found")
else
    local expected = { [1] = 10, [3] = 20, [5] = 30, [7] = 40, [9] = 50 }
    for level, xp in pairs(expected) do
        local actual = ZScienceSkill.skillBookXP[level]
        if actual ~= xp then
            table.insert(errors, string.format(
                "skillBookXP[%d]: expected %d, got %s",
                level, xp, tostring(actual)
            ))
        end
    end
end

-- Test 4: Reading science book grants XP (actual gameplay test)
-- Note: Game has complex XP modifiers (skill level, traits, etc.), so we just verify XP is gained
local xpBefore = player:getXp():getXP(Perks.Science)
local book = instanceItem("Base.Book_Science")
if book then
    player:getInventory():AddItem(book)
    
    -- Simulate completing the book read (call the hooked complete directly)
    local readAction = ISReadABook:new(player, book, 1)
    readAction.character = player
    readAction.item = book
    
    -- Call complete which triggers our XP hook
    local ok, err = pcall(function()
        readAction:complete()
    end)
    
    if not ok then
        table.insert(errors, "ISReadABook:complete() failed: " .. tostring(err))
    else
        local xpAfter = player:getXp():getXP(Perks.Science)
        local xpGained = xpAfter - xpBefore
        
        -- Verify XP was gained (exact amount varies by game settings/modifiers)
        if xpGained <= 0 then
            table.insert(errors, "Science book should grant Science XP, but got 0")
        end
    end
    
    -- Cleanup
    player:getInventory():Remove(book)
else
    table.insert(errors, "Failed to create Base.Book_Science item")
end

-- Test 5: Science book grants more XP than SciFi book (relative test)
local scienceBookXP = 0
local scifiBookXP = 0

local sciBook = instanceItem("Base.Book_Science")
if sciBook then
    player:getInventory():AddItem(sciBook)
    local xpBefore1 = player:getXp():getXP(Perks.Science)
    
    local action1 = ISReadABook:new(player, sciBook, 1)
    action1.character = player
    action1.item = sciBook
    pcall(function() action1:complete() end)
    
    scienceBookXP = player:getXp():getXP(Perks.Science) - xpBefore1
    player:getInventory():Remove(sciBook)
end

local sciFiBook = instanceItem("Base.Book_SciFi")
if sciFiBook then
    player:getInventory():AddItem(sciFiBook)
    local xpBefore2 = player:getXp():getXP(Perks.Science)
    
    local action2 = ISReadABook:new(player, sciFiBook, 1)
    action2.character = player
    action2.item = sciFiBook
    pcall(function() action2:complete() end)
    
    scifiBookXP = player:getXp():getXP(Perks.Science) - xpBefore2
    player:getInventory():Remove(sciFiBook)
end

if scienceBookXP > 0 and scifiBookXP > 0 then
    if scienceBookXP <= scifiBookXP then
        table.insert(errors, string.format(
            "Science book XP (%d) should be greater than SciFi book XP (%d)",
            scienceBookXP, scifiBookXP
        ))
    end
elseif scienceBookXP <= 0 and scifiBookXP <= 0 then
    table.insert(errors, "Neither Science nor SciFi book granted XP")
end

-- Restore instant action setting
player:setTimedActionInstantCheat(wasInstant)

-- Return result
if #errors > 0 then
    return table.concat(errors, "\n")
end

return true
