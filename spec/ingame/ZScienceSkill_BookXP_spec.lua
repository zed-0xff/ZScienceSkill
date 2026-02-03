-- zbtest: Test for ZScienceSkill_BookXP.lua
-- Tests that reading books grants Science XP

require "ZScienceSkill_Data"

local Tests = {}

-- Test: Reading science literature grants Science XP
Tests.test_science_book_grants_xp = function()
    local player = getPlayer()
    
    -- Set timed actions to instant for testing
    local wasInstant = player:isTimedActionInstantCheat()
    player:setTimedActionInstantCheat(true)
    
    -- Get XP before
    local xpBefore = player:getXp():getXP(Perks.Science)
    
    -- Create a science book and add to inventory
    local book = instanceItem("Base.Book_Science")
    player:getInventory():AddItem(book)
    
    -- Read the book (ISReadABook)
    local readAction = ISReadABook:new(player, book, 1)
    ISTimedActionQueue.add(readAction)
    
    -- Wait for action to complete (instant mode)
    while ISTimedActionQueue.hasAction(player) do
        coroutine.yield()
    end
    
    -- Verify XP gained
    local xpAfter = player:getXp():getXP(Perks.Science)
    local xpGained = xpAfter - xpBefore
    local expectedXP = ZScienceSkill.literature["Base.Book_Science"]
    
    -- Restore instant action setting
    player:setTimedActionInstantCheat(wasInstant)
    
    assert(xpGained >= expectedXP, 
        string.format("Expected at least %d Science XP, got %d", expectedXP, xpGained))
    
    return true, string.format("Science book granted %d XP (expected %d)", xpGained, expectedXP)
end

-- Test: Reading skill book grants small Science XP
Tests.test_skill_book_grants_science_xp = function()
    local player = getPlayer()
    
    -- Set timed actions to instant for testing
    local wasInstant = player:isTimedActionInstantCheat()
    player:setTimedActionInstantCheat(true)
    
    -- Get XP before
    local xpBefore = player:getXp():getXP(Perks.Science)
    
    -- Create a carpentry skill book (Vol. 1, level 1)
    local book = instanceItem("Base.BookCarpentry1")
    player:getInventory():AddItem(book)
    
    -- Read the book
    local readAction = ISReadABook:new(player, book, 1)
    ISTimedActionQueue.add(readAction)
    
    -- Wait for action to complete
    while ISTimedActionQueue.hasAction(player) do
        coroutine.yield()
    end
    
    -- Verify XP gained
    local xpAfter = player:getXp():getXP(Perks.Science)
    local xpGained = xpAfter - xpBefore
    local expectedXP = ZScienceSkill.skillBookXP[1] or 10
    
    -- Restore instant action setting
    player:setTimedActionInstantCheat(wasInstant)
    
    assert(xpGained >= expectedXP, 
        string.format("Expected at least %d Science XP from skill book, got %d", expectedXP, xpGained))
    
    return true, string.format("Skill book granted %d Science XP (expected %d)", xpGained, expectedXP)
end

-- Test: SciFi book grants less XP than science book
Tests.test_scifi_book_grants_less_xp = function()
    local player = getPlayer()
    
    -- Set timed actions to instant for testing
    local wasInstant = player:isTimedActionInstantCheat()
    player:setTimedActionInstantCheat(true)
    
    -- Read science book first
    local scienceBook = instanceItem("Base.Book_Science")
    player:getInventory():AddItem(scienceBook)
    
    local xpBefore1 = player:getXp():getXP(Perks.Science)
    local readAction1 = ISReadABook:new(player, scienceBook, 1)
    ISTimedActionQueue.add(readAction1)
    
    while ISTimedActionQueue.hasAction(player) do
        coroutine.yield()
    end
    
    local scienceXP = player:getXp():getXP(Perks.Science) - xpBefore1
    
    -- Read scifi book
    local scifiBook = instanceItem("Base.Book_SciFi")
    player:getInventory():AddItem(scifiBook)
    
    local xpBefore2 = player:getXp():getXP(Perks.Science)
    local readAction2 = ISReadABook:new(player, scifiBook, 1)
    ISTimedActionQueue.add(readAction2)
    
    while ISTimedActionQueue.hasAction(player) do
        coroutine.yield()
    end
    
    local scifiXP = player:getXp():getXP(Perks.Science) - xpBefore2
    
    -- Restore instant action setting
    player:setTimedActionInstantCheat(wasInstant)
    
    assert(scienceXP > scifiXP, 
        string.format("Science book XP (%d) should be greater than SciFi book XP (%d)", 
            scienceXP, scifiXP))
    
    return true, string.format("Science book: %d XP, SciFi book: %d XP", scienceXP, scifiXP)
end

-- Test: Higher level skill books grant more Science XP
Tests.test_higher_skill_books_grant_more_xp = function()
    local player = getPlayer()
    
    -- Set timed actions to instant for testing
    local wasInstant = player:isTimedActionInstantCheat()
    player:setTimedActionInstantCheat(true)
    
    -- Test Vol. 1 (level 1)
    local book1 = instanceItem("Base.BookCarpentry1")
    player:getInventory():AddItem(book1)
    
    local xpBefore1 = player:getXp():getXP(Perks.Science)
    ISTimedActionQueue.add(ISReadABook:new(player, book1, 1))
    
    while ISTimedActionQueue.hasAction(player) do
        coroutine.yield()
    end
    
    local xp1 = player:getXp():getXP(Perks.Science) - xpBefore1
    
    -- Test Vol. 3 (level 5)
    local book3 = instanceItem("Base.BookCarpentry3")
    player:getInventory():AddItem(book3)
    
    local xpBefore3 = player:getXp():getXP(Perks.Science)
    ISTimedActionQueue.add(ISReadABook:new(player, book3, 1))
    
    while ISTimedActionQueue.hasAction(player) do
        coroutine.yield()
    end
    
    local xp3 = player:getXp():getXP(Perks.Science) - xpBefore3
    
    -- Restore instant action setting
    player:setTimedActionInstantCheat(wasInstant)
    
    local expected1 = ZScienceSkill.skillBookXP[1] or 10
    local expected3 = ZScienceSkill.skillBookXP[5] or 30
    
    assert(xp3 > xp1, 
        string.format("Vol.3 XP (%d) should be greater than Vol.1 XP (%d)", xp3, xp1))
    
    return true, string.format("Vol.1: %d XP, Vol.3: %d XP", xp1, xp3)
end

-- Run all tests
local function runTests()
    print("[ZScienceSkill BookXP Tests] Starting...")
    
    for name, testFn in pairs(Tests) do
        local ok, result = pcall(testFn)
        if ok then
            if type(result) == "string" then
                print("[PASS] " .. name .. ": " .. result)
            else
                print("[PASS] " .. name)
            end
        else
            print("[FAIL] " .. name .. ": " .. tostring(result))
        end
    end
    
    print("[ZScienceSkill BookXP Tests] Done!")
end

return {
    Tests = Tests,
    run = runTests,
}
