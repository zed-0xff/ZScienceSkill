-- Test for ZScienceSkill_BookXP.lua
-- Tests requiring player - runs on client and SP only

require "ZBSpec"
require "ZScienceSkill_Data"

-- Data tests (can run without player)
ZBSpec.describe("ZScienceSkill.literature", function()
    it("has science book with 35 XP", function()
        assert.is_table(ZScienceSkill.literature)
        assert.is_equal(35, ZScienceSkill.literature["Base.Book_Science"])
    end)
    
    it("gives more XP for science books than scifi", function()
        local scienceXP = ZScienceSkill.literature["Base.Book_Science"]
        local scifiXP = ZScienceSkill.literature["Base.Book_SciFi"]
        assert.greater_than(scifiXP, scienceXP)
    end)
end)

ZBSpec.describe("ZScienceSkill.skillBookXP", function()
    it("has correct XP progression", function()
        assert.is_equal(10, ZScienceSkill.skillBookXP[1])
        assert.is_equal(20, ZScienceSkill.skillBookXP[3])
        assert.is_equal(30, ZScienceSkill.skillBookXP[5])
        assert.is_equal(40, ZScienceSkill.skillBookXP[7])
        assert.is_equal(50, ZScienceSkill.skillBookXP[9])
    end)
end)

-- Integration tests require player
ZBSpec.player.describe("ISReadABook hook", function()
    local player = getPlayer()
    
    -- Set timed actions to instant for testing
    local wasInstant = player:isTimedActionInstantCheat()
    player:setTimedActionInstantCheat(true)
    
    it("grants Science XP when reading science book", function()
        local xpBefore = player:getXp():getXP(Perks.Science)
        local book = instanceItem("Base.Book_Science")
        assert.is_not_nil(book)
        
        player:getInventory():AddItem(book)
        local action = ISReadABook:new(player, book, 1)
        action.character = player
        action.item = book
        action:complete()
        
        local xpGained = player:getXp():getXP(Perks.Science) - xpBefore
        assert.greater_than(0, xpGained)
        
        player:getInventory():Remove(book)
    end)
    
    it("grants more XP for science book than scifi book", function()
        -- Read science book
        local sciBook = instanceItem("Base.Book_Science")
        player:getInventory():AddItem(sciBook)
        local xpBefore1 = player:getXp():getXP(Perks.Science)
        
        local action1 = ISReadABook:new(player, sciBook, 1)
        action1.character = player
        action1.item = sciBook
        action1:complete()
        
        local scienceXP = player:getXp():getXP(Perks.Science) - xpBefore1
        player:getInventory():Remove(sciBook)
        
        -- Read scifi book
        local sciFiBook = instanceItem("Base.Book_SciFi")
        player:getInventory():AddItem(sciFiBook)
        local xpBefore2 = player:getXp():getXP(Perks.Science)
        
        local action2 = ISReadABook:new(player, sciFiBook, 1)
        action2.character = player
        action2.item = sciFiBook
        action2:complete()
        
        local scifiXP = player:getXp():getXP(Perks.Science) - xpBefore2
        player:getInventory():Remove(sciFiBook)
        
        assert.greater_than(scifiXP, scienceXP)
    end)
    
    -- Restore setting
    player:setTimedActionInstantCheat(wasInstant)
end)

return ZBSpec.run()
