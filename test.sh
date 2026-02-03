#!/bin/bash
# Simple test runner for ZScienceSkill mod

set -e

echo "🧪 Running ZScienceSkill Tests..."
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
    echo "  luarocks install busted  # Install testing framework"
    echo ""
    exit 1
fi

# Run tests
busted --verbose

echo ""
echo "✅ All tests passed!"
