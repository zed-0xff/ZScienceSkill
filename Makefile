.PHONY: setup spec check clean help all

.DEFAULT_GOAL := all

help:
	@echo "ZScienceSkill Development Tasks"
	@echo "==============================="
	@echo ""
	@echo "  make              - Show this help"
	@echo "  make setup        - Install all dependencies"
	@echo "  make spec         - Run Busted unit specs"
	@echo "  make check        - Run static analysis (luacheck)"
	@echo "  make clean        - Remove spec artifacts"
	@echo ""
	@echo "ZBSpec Framework (requires game running):"
	@echo "  zbspec            - Run all specs via framework"
	@echo "  zbspec <file>     - Run specific spec file"
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
	@echo "✅ Setup complete! Run 'make spec' for unit specs or 'zbspec' for integration specs."

spec:
	@echo "🧪 Running unit specs..."
	busted --verbose

check:
	@echo "🔍 Running static analysis..."
	luacheck 42.13/media/lua/

coverage:
	@echo "📊 Running specs with coverage..."
	busted --coverage
	@echo ""
	@echo "📈 Generating coverage report..."
	luacov
	@cat luacov.report.out | head -20

clean:
	@echo "🧹 Cleaning spec artifacts..."
	rm -f luacov.*.out
	rm -f luacov.stats.out
	rm -f luacov.report.out
	@echo "✅ Clean complete!"

all: check spec
	@echo ""
	@echo "=================================================="
	@echo "✅ Local specs passed!"
	@echo "  - Static analysis (luacheck)"
	@echo "  - Unit specs (busted)"
	@echo ""
	@echo "Run 'zbspec' for integration specs (requires game)"
	@echo "=================================================="

watch:
	@echo "👀 Watching for changes..."
	@echo "Note: Install 'entr' with 'brew install entr' for file watching"
	@which entr > /dev/null || (echo "❌ 'entr' not found. Install with: brew install entr" && exit 1)
	@find 42.13/media/lua spec -name '*.lua' | entr -c make spec
