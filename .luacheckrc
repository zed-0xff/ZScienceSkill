-- LuaCheck configuration for ZScienceSkill
std = "lua51+busted"

-- Ignore some common warnings
ignore = {
    "111", -- Setting non-standard global variable (we define our mod namespace)
    "112", -- Mutating non-standard global variable
    "142", -- Setting undefined field (we build our mod table)
    "211", -- Unused local variable
    "212/_.*", -- Unused argument starting with _
    "213", -- Unused loop variable
    "611", -- Line contains only whitespace
    "631", -- Line is too long
}

-- Load PZ globals from external file (DRY!)
-- Luacheck loads .luacheckrc from the project root, so we can use a relative path
local pz_globals = dofile(".luacheckrc_globals.lua")

-- Add mod-specific globals (SSOT)
local mod_globals = {
    "ZScienceSkill",
    "ZScienceSkillOptions",
    "ISResearchSpecimen",  -- Timed action class defined by the mod
}

-- Combine PZ globals + mod globals
globals = {}
for _, g in ipairs(pz_globals) do
    table.insert(globals, g)
end
for _, g in ipairs(mod_globals) do
    table.insert(globals, g)
end

-- Read-only globals (can access but shouldn't modify)
read_globals = {
    -- Standard Lua libraries
    "string",
    "table",
    "math",
    "io",
    "os",
    "debug",
    "coroutine",
    
    -- PZ Java bridge
    "luajava",
}

-- Test files can use additional globals
files["tests/"] = {
    globals = {
        "describe",
        "it",
        "before_each",
        "after_each",
        "setup",
        "teardown",
        "pending",
        "spy",
        "stub",
        "mock",
    }
}

-- Exclude certain directories and test files
exclude_files = {
    ".luarocks/",
    "lua_modules/",
    "tests/",  -- All test files are outside game directories
}

-- Note: To use actual PZ source files for type checking:
-- 1. Ensure PZ is installed at the path above
-- 2. You can reference PZ files in your tests/stubs by adding to package.path
-- 3. LuaCheck doesn't natively support cross-referencing external files for globals,
--    so we maintain this manual list instead
