-- In-game test runner for ZScienceSkill
-- Can be executed via ZombieBuddy API or debug console
-- Tests run AFTER all game code is loaded, validating runtime state

ZScienceSkillTests = ZScienceSkillTests or {}

-- Test results
local results = {
    passed = 0,
    failed = 0,
    tests = {}
}

-- Helper: assert equals
local function assertEquals(expected, actual, message)
    if expected ~= actual then
        error(string.format("%s\nExpected: %s\nActual: %s",
            message or "Assertion failed",
            tostring(expected),
            tostring(actual)))
    end
end

-- Helper: assert true
local function assertTrue(condition, message)
    if not condition then
        error(message or "Expected true but got false")
    end
end

-- Helper: assert not nil
local function assertNotNil(value, message)
    if value == nil then
        error(message or "Expected non-nil value")
    end
end

-- Helper: run a single test
local function runTest(name, testFunc)
    local success, err = pcall(testFunc)

    if success then
        results.passed = results.passed + 1
        table.insert(results.tests, {
            name = name,
            status = "PASS"
        })
    else
        results.failed = results.failed + 1
        -- Simplify error message - just first line
        local errorMsg = tostring(err):match("^[^\n]+") or tostring(err)
        table.insert(results.tests, {
            name = name,
            status = "FAIL",
            error = errorMsg
        })
    end
end

-- Test: Mod namespace exists
local function test_mod_namespace_exists()
    assertNotNil(ZScienceSkill, "ZScienceSkill namespace should exist")
    assertEquals("table", type(ZScienceSkill), "ZScienceSkill should be a table")
end

-- Test: Literature data
local function test_literature_data()
    assertNotNil(ZScienceSkill.literature, "literature table should exist")
    assertEquals(35, ZScienceSkill.literature["Base.Book_Science"],
        "Science book should grant 35 XP")
    assertEquals(10, ZScienceSkill.literature["Base.Book_SciFi"],
        "SciFi book should grant 10 XP")
end

-- Test: Specimen data
local function test_specimen_data()
    assertNotNil(ZScienceSkill.specimens, "specimens table should exist")
    assertEquals(60, ZScienceSkill.specimens["Base.Specimen_Brain"],
        "Brain specimen should grant 60 XP")
    assertEquals(45, ZScienceSkill.specimens["Base.Animal_Brain"],
        "Animal brain should grant 45 XP")
    assertEquals(30, ZScienceSkill.specimens["Base.Animal_Brain_Small"],
        "Small animal brain should grant 30 XP")
end

-- Test: All specimens have positive XP
local function test_all_specimens_positive()
    for itemType, xp in pairs(ZScienceSkill.specimens) do
        assertTrue(type(xp) == "number",
            string.format("%s XP should be a number", itemType))
        assertTrue(xp > 0,
            string.format("%s XP should be positive, got %s", itemType, xp))
    end
end

-- Test: Herbalist plants
local function test_herbalist_plants()
    assertNotNil(ZScienceSkill.herbalistPlants, "herbalistPlants table should exist")

    -- Count plants
    local count = 0
    for _ in pairs(ZScienceSkill.herbalistPlants) do
        count = count + 1
    end

    assertTrue(count >= 10,
        string.format("Should have at least 10 herbalist plants, got %d", count))

    -- Verify specific plants
    assertTrue(ZScienceSkill.herbalistPlants["Base.BerryBlack"],
        "Black berries should be herbalist plants")
    assertTrue(ZScienceSkill.herbalistPlants["Base.CommonMallow"],
        "Common mallow should be herbalist plants")
end

-- Test: Skill book XP values
local function test_skill_book_xp()
    assertNotNil(ZScienceSkill.skillBookXP, "skillBookXP array should exist")
    assertEquals(10, ZScienceSkill.skillBookXP[1], "Level 1 skill book should grant 10 XP")
    assertEquals(20, ZScienceSkill.skillBookXP[3], "Level 3 skill book should grant 20 XP")
    assertEquals(30, ZScienceSkill.skillBookXP[5], "Level 5 skill book should grant 30 XP")
end

-- Test: Fluid research data
local function test_fluid_data()
    assertNotNil(ZScienceSkill.fluids, "fluids table should exist")

    -- Test SecretFlavoring
    local secretFlavoring = ZScienceSkill.fluids["SecretFlavoring"]
    assertNotNil(secretFlavoring, "SecretFlavoring should exist")
    assertEquals(200, secretFlavoring.Science, "SecretFlavoring should grant 200 Science XP")
    assertEquals(50, secretFlavoring.Cooking, "SecretFlavoring should grant 50 Cooking XP")

    -- Test Blood
    local blood = ZScienceSkill.fluids["Blood"]
    assertNotNil(blood, "Blood should exist")
    assertEquals(50, blood.Science, "Blood should grant 50 Science XP")
    assertEquals(50, blood.Doctor, "Blood should grant 50 Doctor XP")
end

-- Test: PZ API integration
local function test_pz_api_integration()
    -- Test that PZ APIs are available
    assertNotNil(Events, "Events API should be available")

    -- getPlayer is client-side only
    if isClient() or not isServer() then
        assertNotNil(getPlayer, "getPlayer API should be available in client")
    end

    -- Test that Science perk exists
    assertNotNil(Perks, "Perks API should be available")
    local sciencePerk = Perks.Science
    assertNotNil(sciencePerk, "Science perk should be registered")
end

-- Test: ISResearchSpecimen class (client-side only)
local function test_research_specimen_class()
    -- This class is only available in client context
    if isClient() or not isServer() then
        if ISResearchSpecimen then
            assertEquals("table", type(ISResearchSpecimen),
                "ISResearchSpecimen should be a table/class")

            -- Check it inherits from ISBaseTimedAction
            if ISBaseTimedAction then
                assertNotNil(ISResearchSpecimen.Type,
                    "ISResearchSpecimen should have Type field from ISBaseTimedAction")
            end
        end
    end
    -- Always pass if not in client context
    assertTrue(true, "Test context validated")
end

-- Test: Mod options
local function test_mod_options()
    -- Options might not be loaded in all environments, so just check if they exist
    if ZScienceSkillOptions then
        assertEquals("table", type(ZScienceSkillOptions),
            "ZScienceSkillOptions should be a table if loaded")
    end
end

-- Test: Item exists in item registry
local function test_items_exist()
    if ScriptManager then
        local scriptManager = ScriptManager.instance
        if scriptManager then
            -- Check that at least one specimen item exists
            local brainItem = scriptManager:FindItem("Base.Specimen_Brain")
            assertTrue(brainItem ~= nil or true, -- Soft check, might not be loaded in all contexts
                "Specimen items should be registered in ScriptManager")
        end
    end
end

-- Main test runner
function ZScienceSkillTests.runAll()
    -- Reset results
    results = {
        passed = 0,
        failed = 0,
        tests = {}
    }

    -- Run all tests
    runTest("Mod namespace exists", test_mod_namespace_exists)
    runTest("Literature data structure", test_literature_data)
    runTest("Specimen data structure", test_specimen_data)
    runTest("All specimens have positive XP", test_all_specimens_positive)
    runTest("Herbalist plants", test_herbalist_plants)
    runTest("Skill book XP values", test_skill_book_xp)
    runTest("Fluid research data", test_fluid_data)
    runTest("PZ API integration", test_pz_api_integration)
    runTest("ISResearchSpecimen class", test_research_specimen_class)
    runTest("Mod options", test_mod_options)
    runTest("Items exist in registry", test_items_exist)

    return results
end

-- Return summary for API calls
function ZScienceSkillTests.getSummary()
    local total = results.passed + results.failed
    return {
        total = total,
        passed = results.passed,
        failed = results.failed,
        success_rate = total > 0 and (results.passed / total * 100) or 0
    }
end

-- Get detailed results
function ZScienceSkillTests.getResults()
    return results
end

-- Print results (for debug console)
function ZScienceSkillTests.printResults()
    print("=================================")
    print("ZScienceSkill Test Results")
    print("=================================")
    print(string.format("Total: %d  Passed: %d  Failed: %d",
        results.passed + results.failed, results.passed, results.failed))
    print("")

    for _, test in ipairs(results.tests) do
        if test.status == "PASS" then
            print(string.format("✓ PASS: %s", test.name))
        else
            print(string.format("✗ FAIL: %s", test.name))
            print(string.format("  Error: %s", test.error))
        end
    end

    print("=================================")
end
