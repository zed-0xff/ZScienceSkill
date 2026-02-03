.PHONY: setup test check clean help all test-ingame test-load

.DEFAULT_GOAL := all

test-ingame:
	@echo "🧪 Running in-game tests (requires game running on :4444)..."
	./test_ingame_simple.sh

test-load:
	@echo "🔍 Validating all Lua files (syntax + runtime)..."
	./test_load_all.sh

help:
	@echo "ZScienceSkill Development Tasks"
	@echo "==============================="
	@echo ""
	@echo "  make              - Run ALL tests (requires game running)"
	@echo "  make setup        - Install all dependencies"
	@echo "  make test         - Run Busted unit tests"
	@echo "  make test-ingame  - Run in-game tests (requires game + ZombieBuddy)"
	@echo "  make test-load    - Validate all .lua files (syntax + runtime)"
	@echo "  make check        - Run static analysis (luacheck)"
	@echo "  make clean        - Remove test artifacts"
	@echo ""

setup:
	@echo "📦 Installing Homebrew dependencies..."
	brew bundle
	@echo ""
	@echo "📦 Installing Lua testing tools..."
	luarocks install busted
	luarocks install luacheck
	luarocks install luacov
	@echo ""
	@echo "✅ Setup complete! Run 'make test' to run tests."

test:
	@echo "🧪 Running tests..."
	busted --verbose

check:
	@echo "🔍 Running static analysis..."
	luacheck 42.13/media/lua/

coverage:
	@echo "📊 Running tests with coverage..."
	busted --coverage
	@echo ""
	@echo "📈 Generating coverage report..."
	luacov
	@cat luacov.report.out | head -20

clean:
	@echo "🧹 Cleaning test artifacts..."
	rm -f luacov.*.out
	rm -f luacov.stats.out
	rm -f luacov.report.out
	@echo "✅ Clean complete!"

all: check test test-load test-ingame
	@echo ""
	@echo "=================================================="
	@echo "✅ All tests passed!"
	@echo "  - Static analysis (luacheck)"
	@echo "  - Unit tests (busted)"
	@echo "  - File validation (syntax + runtime)"
	@echo "  - In-game integration tests"
	@echo "=================================================="

watch:
	@echo "👀 Watching for changes..."
	@echo "Note: Install 'entr' with 'brew install entr' for file watching"
	@which entr > /dev/null || (echo "❌ 'entr' not found. Install with: brew install entr" && exit 1)
	@find 42.13/media/lua tests -name '*.lua' | entr -c make test
