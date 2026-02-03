# Testing Guide for ZScienceSkill

## Quick Start

```bash
# 1. Install dependencies (one-time setup)
make setup

# 2. Run tests
make test

# 3. Run static analysis
make check
```

## Manual Setup

If you prefer to install dependencies manually:

```bash
# Install Homebrew dependencies
brew bundle

# Install Lua testing tools
luarocks install busted
luarocks install luacheck
luarocks install luacov
```

## Running Tests

### Basic Usage

```bash
# Run all tests
busted

# Run specific test file
busted tests/unit/ZScienceSkill_Data_spec.lua

# Verbose output
busted --verbose

# With coverage
busted --coverage
```

### Using Make

```bash
# Run tests
make test

# Run static analysis
make check

# Run both
make all

# Generate coverage report
make coverage

# Watch files and auto-run tests on changes
make watch  # requires 'entr'
```

## Static Analysis

Check your code for issues:

```bash
# Check all Lua files
luacheck 42.13/media/lua/

# Check specific file
luacheck 42.13/media/lua/shared/ZScienceSkill_Data.lua

# Or use make
make check
```

## Test Structure

```
ZScienceSkill/
├── Brewfile                 # Homebrew dependencies
├── Makefile                 # Build automation
├── .busted                  # Busted configuration
├── .luacheckrc              # LuaCheck configuration
├── tests/
│   ├── unit/                # Unit tests
│   │   └── ZScienceSkill_Data_spec.lua
│   ├── integration/         # Integration tests (future)
│   └── README.md
└── 42.13/media/lua/         # Source code
    ├── client/
    ├── server/
    └── shared/
```

## Writing New Tests

Create a new test file in `tests/unit/`:

```lua
describe("MyModule", function()
    local MyModule
    
    setup(function()
        package.path = package.path .. ";42.13/media/lua/shared/?.lua"
        MyModule = require("MyModule")
    end)
    
    it("should do something", function()
        assert.equals("expected", MyModule.someFunction())
    end)
end)
```

## Common Issues

### busted: command not found

Install busted:
```bash
luarocks install busted
```

### Module not found

Check your `package.path` in the test file:
```lua
package.path = package.path .. ";42.13/media/lua/shared/?.lua"
```

### Global variable warnings

Add globals to `.luacheckrc`:
```lua
globals = {
    "MyGlobalVariable",
}
```

## CI/CD Integration

For GitHub Actions, see `.github/workflows/test.yml` (to be created).

## Resources

- [Busted Documentation](https://olivinelabs.com/busted/)
- [LuaCheck Documentation](https://luacheck.readthedocs.io/)
- [Lua 5.1 Reference](https://www.lua.org/manual/5.1/)
