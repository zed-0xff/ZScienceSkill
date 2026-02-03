.PHONY: setup test check clean help all

.DEFAULT_GOAL := all

test-api:
	@echo "🧪 Running API tests (requires game running on :4444)..."
	./test_api.sh

help:
	@echo "ZScienceSkill Development Tasks"
	@echo "==============================="
	@echo ""
	@echo "  make setup      - Install all dependencies"
	@echo "  make test       - Run Busted unit tests"
	@echo "  make test-api   - Run API tests (game must be running)"
	@echo "  make check      - Run static analysis (luacheck)"
	@echo "  make clean      - Remove test artifacts"
	@echo "  make all        - Run check + test"
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

all: check test

watch:
	@echo "👀 Watching for changes..."
	@echo "Note: Install 'entr' with 'brew install entr' for file watching"
	@which entr > /dev/null || (echo "❌ 'entr' not found. Install with: brew install entr" && exit 1)
	@find 42.13/media/lua tests -name '*.lua' | entr -c make test
