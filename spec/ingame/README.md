# In-Game Specs for ZScienceSkill

Specs that run inside the actual game with real PZ API.

## Quick Start

### Option 1: F12 Hotkey (Quickest)

1. Launch PZ in debug mode
2. Load your save
3. Press **F12** to run all specs
4. Check console output for results

### Option 2: Console Command

```lua
-- In debug console
require "spec/ingame/ZScienceSkillTests"
ZScienceSkillTests.runAll()

-- Or run individual spec
ZScienceSkillTests.runOne("research_brain_specimen")
```

### Option 3: Integrate with PZ Debug Menu

The specs follow PZ's test framework pattern and can be integrated into the official debug menu (F11 -> Unit Tests) by creating a UI panel.

## Available Specs

### `research_brain_specimen`
- Creates a brain specimen and microscope
- Executes research timed action
- Verifies XP gain and researched flag

### `research_science_book`
- Validates science book XP values
- Checks data structure integrity

### `verify_insect_xp`
- Tests specimen XP lookup
- Validates insect XP values

### `herbalist_plants_count`
- Counts herbalist plants
- Verifies minimum required count

### `no_duplicate_research`
- Tests that already-researched items don't grant XP again
- Validates modData persistence

## How It Works

```lua
-- Spec structure (based on PZ's pattern)
Specs.my_spec = {
    run = function(self)
        -- Setup: Create items, set state
        local item = newInventoryItem("Base.Item")
        self.item = item
        
        -- Execute: Run timed actions
        ISTimedActionQueue.add(MyAction:new(player, item, 100))
    end,
    
    verify = function(self)
        -- Verify: Check results after action completes
        if checkSomething() then
            return true, "Success message"
        else
            return false, "Error message"
        end
    end
}
```

## Console Output Example

```
[ZScienceSkill Specs] Loaded! Press F12 to run specs in-game.
[ZScienceSkill Specs] Running all specs...
[ZScienceSkill Specs] Running: research_brain_specimen
[ZScienceSkill Specs] ✓ research_brain_specimen: Gained 60 Science XP
[ZScienceSkill Specs] Running: research_science_book
[ZScienceSkill Specs] ✓ research_science_book: Science book XP value correct: 35
[ZScienceSkill Specs] All specs completed!
```

## Adding New Specs

```lua
-- In ZScienceSkillTests.lua, add to Specs table:
Specs.my_new_spec = {
    run = function(self)
        -- Your spec setup
        local player = getPlayer()
        local item = newInventoryItem("Base.YourItem")
        
        -- Store state for verify
        self.player = player
        self.item = item
    end,
    
    verify = function(self)
        -- Check results
        if self.item:getModData().something then
            return true, "Spec passed!"
        end
        return false, "Spec failed!"
    end
}
```

## Helper Functions Available

- `newInventoryItem(type)` - Add item to player inventory
- `newObject(x, y, z, sprite, name)` - Create world object
- `removeAllButFloor(square)` - Clean up square
- `getSquareDelta(dx, dy, dz)` - Get square relative to player
- `luautils.walkAdj(player, square)` - Walk player to square

## Benefits vs Busted Tests

**Busted (Outside Game)**
- ✅ Fast feedback (seconds)
- ✅ No game launch needed
- ✅ Good for data/logic testing
- ❌ Must mock PZ API
- ❌ Can't test actual gameplay

**In-Game Specs**
- ✅ Real PZ API (no mocks!)
- ✅ Test actual gameplay flow
- ✅ Visual verification
- ✅ Test UI interactions
- ❌ Slower (requires game launch)
- ❌ Manual execution

## Best Practice

Use **both**:
1. **Busted** for unit specs (data structures, pure logic)
2. **In-game** for integration specs (timed actions, gameplay)

Run Busted specs before committing, run in-game specs for manual QA.
