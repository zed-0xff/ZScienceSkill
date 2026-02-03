-- Test for ZScienceSkill_BookXP.lua

-- Inline mini test framework
local tests, errors, currentDescribe = {}, {}, ""
local function describe(name, fn) currentDescribe = name; fn(); currentDescribe = "" end
local function it(name, fn) table.insert(tests, { name = currentDescribe .. " " .. name, fn = fn }) end
local assert = {
    is_equal = function(exp, act) if exp ~= act then error(string.format("expected %s, got %s", tostring(exp), tostring(act))) end end,
    is_not_nil = function(v) if v == nil then error("expected non-nil") end end,
    is_table = function(v) if type(v) ~= "table" then error("expected table") end end,
    greater_than = function(exp, act) if not (act > exp) then error(string.format("expected %s > %s", tostring(act), tostring(exp))) end end,
}
local function run_specs()
    for _, t in ipairs(tests) do
        local ok, err = pcall(t.fn)
        if not ok then table.insert(errors, t.name .. ": " .. tostring(err)) end
    end
    if #errors > 0 then return table.concat(errors, "\n") end
    return true
end

require "ZScienceSkill_Data"

local player = getPlayer()
if not player then
    return "getPlayer() returned nil - player not loaded"
end

-- Set timed actions to instant for testing
local wasInstant = player:isTimedActionInstantCheat()
player:setTimedActionInstantCheat(true)

describe("ZScienceSkill.literature", function()
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

describe("ZScienceSkill.skillBookXP", function()
    it("has correct XP progression", function()
        assert.is_equal(10, ZScienceSkill.skillBookXP[1])
        assert.is_equal(20, ZScienceSkill.skillBookXP[3])
        assert.is_equal(30, ZScienceSkill.skillBookXP[5])
        assert.is_equal(40, ZScienceSkill.skillBookXP[7])
        assert.is_equal(50, ZScienceSkill.skillBookXP[9])
    end)
end)

describe("ISReadABook hook", function()
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
end)

-- Restore setting
player:setTimedActionInstantCheat(wasInstant)

return run_specs()
