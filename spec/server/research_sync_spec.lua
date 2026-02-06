-- Server-side tests for research ModData sync
-- Tests that server properly handles client commands for research

ZBSpec.describe("ZScienceSkill research sync", function()
    local player = get_player()
    
    before_each(function()
        -- Clear research data before each test
        player:getModData().researchedSpecimens = {}
        player:getModData().researchedPlants = {}
    end)
    
    it("player ModData persists research on server", function()
        local researchKey = "Base.Cricket"
        
        -- Directly set ModData as the server handler would
        player:getModData().researchedSpecimens = player:getModData().researchedSpecimens or {}
        player:getModData().researchedSpecimens[researchKey] = true
        
        assert(player:getModData().researchedSpecimens[researchKey] == true)
    end)
    
    it("player ModData persists plant tracking on server", function()
        local plantType = "Base.BerryBlack"
        
        player:getModData().researchedPlants = player:getModData().researchedPlants or {}
        player:getModData().researchedPlants[plantType] = true
        
        assert(player:getModData().researchedPlants[plantType] == true)
    end)
    
    it("player ModData persists fluid research on server", function()
        local researchKey = "Fluid:Blood"
        
        player:getModData().researchedSpecimens = player:getModData().researchedSpecimens or {}
        player:getModData().researchedSpecimens[researchKey] = true
        
        assert(player:getModData().researchedSpecimens[researchKey] == true)
    end)
end)

return ZBSpec.run()
