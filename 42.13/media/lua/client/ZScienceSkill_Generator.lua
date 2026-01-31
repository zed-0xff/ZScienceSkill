-- Generator improvements based on Science skill
-- Reduces failure chance and improves repair effectiveness

require "TimedActions/ISActivateGenerator"
require "TimedActions/ISFixGenerator"

-- Reduce failure-to-start chance based on Science level
-- Vanilla: 50% fail when condition <= 50
-- With Science: lower threshold and/or better odds
local originalActivateComplete = ISActivateGenerator.complete

function ISActivateGenerator:complete()
    if not self.generator then return end
    
    if self.activate then
        local condition = self.generator:getCondition()
        local scienceLevel = self.character:getPerkLevel(Perks.Science)
        
        -- Science lowers the condition threshold for failure
        -- Vanilla: fails when condition <= 50
        -- Science 10: fails only when condition <= 25
        local failThreshold = 50 - (scienceLevel * 2.5)
        
        -- Science also improves success odds when below threshold
        -- Vanilla: ZombRand(2) == 0 means 50% fail
        -- Science adds more favorable odds: ZombRand(2 + scienceLevel/2)
        local failChance = 2 + math.floor(scienceLevel / 2)
        
        if condition <= failThreshold and ZombRand(failChance) == 0 then
            self.generator:failToStart()
        else
            self.generator:setActivated(self.activate)
        end
    else
        self.generator:setActivated(self.activate)
    end
    
    self.generator:sync()
    return true
end

-- Improve repair effectiveness based on Science level
-- Stacks with Electricity bonus
local originalFixComplete = ISFixGenerator.complete

function ISFixGenerator:complete()
    local scrapItem = self.character:getInventory():getFirstTypeRecurse("ElectronicsScrap")
    if not scrapItem then return false end
    
    self.character:removeFromHands(scrapItem)
    self.character:getInventory():Remove(scrapItem)
    sendRemoveItemFromContainer(self.character:getInventory(), scrapItem)
    
    -- Vanilla: 4 + (electricityLevel / 2)
    -- Science bonus: +1 condition per 2 Science levels
    local electricityLevel = self.character:getPerkLevel(Perks.Electricity)
    local scienceLevel = self.character:getPerkLevel(Perks.Science)
    local baseRepair = 4 + (electricityLevel / 2)
    local scienceBonus = scienceLevel / 2
    
    self.generator:setCondition(self.generator:getCondition() + baseRepair + scienceBonus)
    addXp(self.character, Perks.Electricity, 5)
    
    -- Small Science XP for repairs
    if scienceLevel > 0 then
        self.character:getXp():AddXP(Perks.Science, 2)
    end
    
    if not isClient() and not isServer() then
        self:continueFixing()
    end
    
    return true
end

-- Speed up repairs based on Science level
local originalFixGetDuration = ISFixGenerator.getDuration

function ISFixGenerator:getDuration()
    if self.character:isTimedActionInstant() then
        return 1
    end
    
    local electricityLevel = self.character:getPerkLevel(Perks.Electricity)
    local scienceLevel = self.character:getPerkLevel(Perks.Science)
    
    -- Vanilla: 150 - (electricityLevel * 3)
    -- Science bonus: additional 2% speed per level
    local baseTime = 150 - (electricityLevel * 3)
    local scienceMultiplier = 1 - (scienceLevel * 0.02)
    
    return baseTime * scienceMultiplier
end
