# Project Structure

## Directory Organization

```
ZScienceSkill/
├── 42.13/media/lua/          # Game loads from here (production code only)
│   ├── client/               # Client-side code (10 files)
│   ├── server/               # Server-side code (2 files)
│   └── shared/               # Shared code (1 file)
├── common/                   # Game loads from here (mod.info, assets)
├── spec/                     # Spec files (NOT loaded by game)
│   ├── unit/                 # Busted unit specs
│   ├── ingame/               # In-game integration specs
│   └── zbspec.yml            # ZBSpec framework configuration
├── tools/                    # Build/dev tools
├── .luacheckrc               # Linter configuration
├── .busted                   # Busted configuration
└── Makefile                  # Build automation
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
- `ZScienceSkill_ISResearchSpecimen.lua`
- `ZScienceSkill_Tooltip.lua`
- `ZScienceSkill_XPBoost.lua`

### Server (2 files)
- `ZScienceSkill_Distributions.lua`
- `ZScienceSkill_SkillBook.lua`

### Shared (1 file)
- `ZScienceSkill_Data.lua`

## Spec Files (NOT loaded by game)

**These are in `spec/` directory:**

### Unit Specs (Busted)
- `spec/unit/ZScienceSkill_Data_spec.lua`

### In-Game Specs (ZombieBuddy API)
- `spec/ingame/ZScienceSkillTests.lua` - F12-triggered in-game specs with timed actions
- `spec/ingame/ZScienceSkill_BookXP_spec.lua` - Specific book XP testing

### Framework (ZBSpec - Ruby)
- `spec/zbspec.yml` - Configuration (YAML)

## Important Rules

✅ **Production code** goes in `42.13/media/lua/` or `common/`  
✅ **Spec code** goes in `spec/`  
✅ **Tools/scripts** stay at project root or in `tools/`

❌ **Never put spec files in game directories** - game will load them!  
❌ **Never put production code in `spec/`** - it won't load!

## Running Specs

```bash
# Run unit specs with Busted
make spec

# Run all specs via ZBSpec framework (requires game running)
zbspec

# Run specific spec file
zbspec spec/ingame/ZScienceSkill_BookXP_spec.lua

# Static analysis
make check
```
