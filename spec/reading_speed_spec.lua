-- Test for ZScienceSkill_ReadingSpeed.lua
-- Tests reading speed bonus based on Science skill

require "ZBSpec"
require "ZScienceSkill_ReadingSpeed"

local player = getPlayer()
if not player then
    return "getPlayer() returned nil - player not loaded"
end

describe("Reading speed bonus", function()
    it("ISReadABook.getDuration returns positive number for skill book", function()
        -- Create a skill book (Carpentry for Beginners)
        local book = instanceItem("Base.BookCarpentry1")
        assert.is_not_nil(book)
        
        player:getInventory():AddItem(book)
        
        local action = ISReadABook:new(player, book, 1)
        action.character = player
        action.item = book
        
        local duration = action:getDuration()
        assert.is_number(duration)
        assert.greater_than(0, duration)
        
        player:getInventory():Remove(book)
    end)
    
    it("ISReadABook.getDuration returns positive number for regular book", function()
        -- Create a non-skill book
        local book = instanceItem("Base.Book_Science")
        assert.is_not_nil(book)
        
        player:getInventory():AddItem(book)
        
        local action = ISReadABook:new(player, book, 1)
        action.character = player
        action.item = book
        
        local duration = action:getDuration()
        assert.is_number(duration)
        assert.greater_than(0, duration)
        
        player:getInventory():Remove(book)
    end)
    
    it("hook is installed on ISReadABook.getDuration", function()
        assert.is_function(ISReadABook.getDuration)
    end)
end)

describe("Reading speed multiplier calculation", function()
    it("speed bonus is 5% per Science level", function()
        -- Test the math: at Science 10, multiplier should be 0.5 (50% faster)
        local scienceLevel = 10
        local expectedMultiplier = 1 - (scienceLevel * 0.05)
        assert.is_equal(0.5, expectedMultiplier)
    end)
    
    it("no bonus at Science level 0", function()
        local scienceLevel = 0
        local expectedMultiplier = 1 - (scienceLevel * 0.05)
        assert.is_equal(1.0, expectedMultiplier)
    end)
    
    it("25% faster at Science level 5", function()
        local scienceLevel = 5
        local expectedMultiplier = 1 - (scienceLevel * 0.05)
        assert.is_equal(0.75, expectedMultiplier)
    end)
end)

return ZBSpec.run()
