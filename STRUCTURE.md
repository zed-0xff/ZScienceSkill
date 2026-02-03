# Project Structure

## Directory Organization

```
ZScienceSkill/
├── 42.13/media/lua/          # Game loads from here (production code only)
│   ├── client/               # Client-side code (10 files)
│   ├── server/               # Server-side code (2 files)
│   └── shared/               # Shared code (1 file)
├── common/                   # Game loads from here (currently empty)
├── tests/                    # Test files (NOT loaded by game)
│   ├── unit/                 # Busted unit tests
│   └── ingame/               # In-game integration tests
├── tools/                    # Build/dev tools
├── .luacheckrc               # Linter configuration
├── .busted                   # Test runner configuration
├── Makefile                  # Build automation
└── test_*.sh                 # Test scripts
```

## Production Files (13 files)

**Game loads these automatically from `42.13/media/lua/` and `common/`:**

### Client (10 files)
- `ZScienceSkill_BookXP.lua`
- `ZScienceSkill_ElectricalXP.lua`
- `ZScienceSkill_Medical.lua`
- `ZScienceSkill_ModOptions.lua`
- `ZScienceSkill_OverlayIcon.lua`
- `ZScienceSkill_ReadingSpeed.lua`
- `ZScienceSkill_ResearchRecipe.lua`
- `ZScienceSkill_ResearchSpecimen.lua`
- `ZScienceSkill_Tooltip.lua`
- `ZScienceSkill_XPBoost.lua`

### Server (2 files)
- `ZScienceSkill_Distributions.lua`
- `ZScienceSkill_SkillBook.lua`

### Shared (1 file)
- `ZScienceSkill_Data.lua`

## Test Files (NOT loaded by game)

**These are in `tests/` directory:**

### Unit Tests (Busted)
- `tests/unit/ZScienceSkill_Data_spec.lua`

### In-Game Tests (ZombieBuddy API)
- `tests/ingame/ZScienceSkillTests.lua`
- `tests/ingame/ZScienceSkill_TestRunner.lua`
- `tests/ingame/ZScienceSkill_TestLoader.lua`

## Important Rules

✅ **Production code** goes in `42.13/media/lua/` or `common/`  
✅ **Test code** goes in `tests/`  
✅ **Tools/scripts** stay at project root or in `tools/`

❌ **Never put test files in game directories** - game will load them!  
❌ **Never put production code in `tests/`** - it won't load!

## Validation

Run `make test-load` to verify:
- Only production files (13) are validated
- No test files in game directories
- All files have valid syntax
