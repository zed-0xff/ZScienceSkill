# ZScienceSkill Tests

## Setup

Install Busted (Lua testing framework):

```bash
# Using LuaRocks
luarocks install busted

# Or via Homebrew on macOS
brew install luarocks
luarocks install busted
```

## Running Tests

From the mod root directory:

```bash
# Run all tests
busted

# Run a specific test file
busted tests/unit/ZScienceSkill_Data_spec.lua

# Run with verbose output
busted --verbose

# Run with coverage
busted --coverage
```

## Project Structure

```
ZScienceSkill/
├── 42.13/media/lua/         # Source code
│   ├── client/
│   ├── server/
│   └── shared/
└── tests/                   # Test files
    ├── unit/                # Unit tests
    └── README.md            # This file
```

## Writing Tests

Tests are written using Busted's BDD-style syntax:

```lua
describe("Feature name", function()
    setup(function()
        -- Run once before all tests
    end)
    
    before_each(function()
        -- Run before each test
    end)
    
    it("should do something", function()
        assert.equals(expected, actual)
    end)
end)
```

### Common Assertions

- `assert.equals(expected, actual)` - values are equal
- `assert.is_true(value)` - value is true
- `assert.is_false(value)` - value is false
- `assert.is_table(value)` - value is a table
- `assert.is_string(value)` - value is a string
- `assert.is_number(value)` - value is a number
- `assert.matches(pattern, value)` - value matches pattern

## Test Coverage

Current test files:

- `ZScienceSkill_Data_spec.lua` - Tests for data structures and XP values

## Contributing

When adding new features:

1. Write tests first (TDD)
2. Ensure all tests pass before committing
3. Keep tests simple and focused
4. Use descriptive test names
