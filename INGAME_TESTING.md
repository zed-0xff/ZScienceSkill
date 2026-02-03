# In-Game Testing

## Overview

This document describes how to run **in-game tests** that execute AFTER all game code is loaded. This validates that your mod works correctly in the real Project Zomboid runtime environment, not just in isolated unit tests.

## Why In-Game Testing?

Traditional unit tests (Busted) run in isolation and don't have access to:
- ❌ Project Zomboid's Java-Lua bridge
- ❌ Game initialization code
- ❌ Real PZ API objects (Perks, Events, ScriptManager, etc.)
- ❌ Other mods that might conflict
- ❌ Actual game state

**In-game tests solve this** by running inside a live game instance after everything is loaded!

## Prerequisites

1. **Install ZombieBuddy mod**  
   https://steamcommunity.com/sharedfiles/filedetails/?id=2927077591

2. **Enable Lua API server**  
   In ZombieBuddy settings, enable: `lua_server_port`

3. **Start the game**  
   API server will run on port 4444

4. **Verify connection**
   ```bash
   curl -s -X POST 'http://127.0.0.1:4444/lua' -d 'return "hello"'
   # Should return: "hello"
   ```

## Running Tests

```bash
# Using make
make test-ingame

# Or directly
./test_ingame_simple.sh
```

## What Gets Tested

1. ✅ **Mod namespace exists** - `ZScienceSkill` table is created
2. ✅ **Literature data** - Book XP values are correct
3. ✅ **Specimen data** - Research XP values are correct
4. ✅ **All specimens positive** - Every specimen has valid XP > 0
5. ✅ **Herbalist plants** - Sufficient plants defined
6. ✅ **Skill book XP** - Tiered XP values correct
7. ✅ **Fluid research** - Multi-skill XP bonuses work
8. ✅ **Events API** - PZ event system available
9. ✅ **Science perk** - Custom perk is registered
10. ✅ **Research action class** - ISResearchSpecimen loaded

## Manual Testing via API

You can run arbitrary Lua code in the game:

```bash
# Check if mod is loaded
curl -s -X POST 'http://127.0.0.1:4444/lua?depth=5' -d 'return ZScienceSkill'

# Test a specific value
curl -s -X POST 'http://127.0.0.1:4444/lua' -d '
return ZScienceSkill.specimens["Base.Specimen_Brain"]
'

# Run custom test logic
curl -s -X POST 'http://127.0.0.1:4444/lua?depth=3' -d '
local count = 0
for _ in pairs(ZScienceSkill.herbalistPlants) do
    count = count + 1
end
return {plant_count = count}
'

# Check game state
curl -s -X POST 'http://127.0.0.1:4444/lua' -d '
local player = getPlayer()
return {
    has_player = player ~= nil,
    science_level = player and player:getPerkLevel(Perks.Science) or 0
}
'
```

## Development Workflow

### Fast Iteration Loop

1. **Edit code** in your IDE
2. **Reload mod** in game (F11 or restart)
3. **Run tests** via API: `make test-ingame`
4. **Repeat** - No need to restart game!

### Complete Test Suite

```bash
# Static analysis (instant)
make check

# Unit tests (seconds)
make test

# In-game validation (with game running)
make test-ingame
```

## Troubleshooting

### Connection Refused

```
curl: (7) Failed to connect to 127.0.0.1 port 4444: Connection refused
```

**Fix**: 
1. Make sure game is running
2. Check ZombieBuddy mod is enabled
3. Verify `lua_server_port` is enabled in settings

### Mod Not Found

```
{"error":"attempt to index a nil value (global 'ZScienceSkill')"}
```

**Fix**: 
1. Ensure mod is in correct directory
2. Check `mod.info` file exists
3. Reload mods in game (F11)

### Java RuntimeException

This usually means:
- Trying to access client-side API from server context
- Accessing undefined Java object
- Depth parameter too low for complex tables

**Fix**: Use `?depth=5` or higher for complex objects

## Advanced: Custom Test Scripts

Create your own test file:

```lua
-- 42.13/media/lua/shared/MyModTests.lua

MyModTests = {}

function MyModTests.runAll()
    -- Your test logic here
    local results = {
        test1 = (ZScienceSkill ~= nil),
        test2 = (ZScienceSkill.literature["Base.Book_Science"] == 35),
        -- ... more tests
    }
    return results
end
```

Then run via API:

```bash
curl -s -X POST 'http://127.0.0.1:4444/lua?depth=5' -d '
require "MyModTests"
return MyModTests.runAll()
'
```

## Benefits Over Unit Tests

| Aspect | Unit Tests | In-Game Tests |
|--------|-----------|---------------|
| Speed | Fast (seconds) | Slower (~5 sec) |
| Setup | None | Game must run |
| Coverage | Pure Lua logic | Full integration |
| PZ API | ❌ Mocked | ✅ Real |
| Mod conflicts | ❌ Not tested | ✅ Detected |
| Java bridge | ❌ Not tested | ✅ Validated |

## Recommended Strategy

1. **Unit tests** - For data structures, pure logic
2. **In-game tests** - For integration, PZ API, runtime behavior
3. **Manual QA** - For UI, gameplay feel, edge cases

All three together give you **confidence your mod works!**
