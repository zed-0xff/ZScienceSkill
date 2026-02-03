# Science, Bitch!

A Project Zomboid mod that adds a Science skill. Research specimens at microscopes, read science books, and gain bonuses to learning and medical treatments.

## Features

### Research Specimens
Found a jar with a brain in it? A dead rat? Some weird mushrooms? Now you can actually study them! Just find a microscope, plop your specimen nearby, and get that sweet Science XP.

**Pro tip**: Pay extra attention to plants, berries, and mushrooms. Rumor has it that studying enough of them might unlock something... useful. 👀

Look for the small gray **"R"** on item icons - that means you haven't read/researched it yet and it can give you Science XP!

### Faster Learning
Higher Science = faster skill book reading.
- Up to 50% faster at Science 10
- Also speeds up recipe research from items

### XP Boost
Science makes you smarter at everything (except punching zombies):
- +2% bonus to all non-combat XP per Science level
- That's +20% at max level

### Electrical Synergy
- Gain Science XP when gaining Electrical XP (half amount)

### Medical Knowledge
- Bandages last longer (+5% per Science level)
- Faster medical treatments (bandaging, disinfecting, splinting)

## How to Level Science

- Read Science books and magazines
- Read SciFi books (small amount - it's fiction, but it inspires curiosity!)
- Read ANY skill book (tiny amount)
- Research specimens at a microscope
- Research recipes from items
- Do electrical stuff

## Researchable Items

Pretty much anything that looks sciency:
- Specimen jars (brain, insects, fetal animals, etc.)
- Dead critters (rats, mice, birds, squirrels)
- Insects, berries, mushrooms
- Medicinal plants
- Gems, crystals, minerals
- Medical equipment
- Animal dung (grants Tracking XP too!)
- Pills (grants Doctor XP too!)
- Various fluids (Acid, Blood, etc.)

## Requirements

- Game version 42.13+
- No other mods required

## Compatibility

Should work with most mods. Hooks into vanilla functions cleanly and calls originals when possible.

## Development

### Running Tests

This mod uses [ZBSpec](https://github.com/zed-0xff/ZBSpec) for in-game testing.

```bash
cd mods/ZScienceSkill
zbspec
```

### Project Structure

```
ZScienceSkill/
├── 42.13/
│   └── media/lua/
│       ├── client/          # Client-side code
│       ├── server/          # Server-side code
│       └── shared/          # Shared data
├── common/
│   └── mod.info
├── spec/                    # ZBSpec test files
│   ├── zbspec.yml
│   ├── data_spec.lua
│   ├── specimen_spec.lua
│   └── book_xp_spec.lua
└── steam.txt
```

## Related Projects

- [ZombieBuddy](https://github.com/zed-0xff/ZombieBuddy) - Java modding framework for Project Zomboid
- [ZBSpec](https://github.com/zed-0xff/ZBSpec) - Testing framework for PZ mods

## Support

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/zed_0xff)

## License

MIT
