#!/bin/bash
# Simple spec runner for ZScienceSkill mod

set -e

echo "🧪 Running ZScienceSkill Specs..."
echo "================================="

# Check if busted is installed
if ! command -v busted &> /dev/null; then
    echo "❌ Error: busted is not installed"
    echo ""
    echo "Quick setup:"
    echo "  make setup"
    echo ""
    echo "Or install manually:"
    echo "  brew bundle              # Install Lua/LuaRocks"
    echo "  luarocks install busted  # Install spec framework"
    echo ""
    exit 1
fi

# Run specs
busted --verbose

echo ""
echo "✅ All specs passed!"
