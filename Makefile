.PHONY: setup spec check clean help all

.DEFAULT_GOAL := all

help:
	@echo "ZScienceSkill Development Tasks"
	@echo "==============================="
	@echo ""
	@echo "  make              - Run check + spec"
	@echo "  make setup        - Install dependencies"
	@echo "  make check        - Run static analysis (luacheck)"
	@echo "  make spec         - Run ZBSpec tests (requires game running)"
	@echo "  make clean        - Remove artifacts"
	@echo ""

setup:
	@echo "📦 Installing Homebrew dependencies..."
	brew bundle
	@echo ""
	@echo "📦 Installing Lua tools..."
	luarocks install luacheck
	@echo ""
	@echo "✅ Setup complete!"

check:
	@echo "🔍 Running static analysis..."
	luacheck 42.13/media/lua/

spec:
	@echo "🧪 Running ZBSpec tests (game must be running)..."
	zbspec

clean:
	@echo "🧹 Cleaning artifacts..."
	rm -f luacov.*.out
	rm -f luacov.stats.out
	rm -f luacov.report.out
	@echo "✅ Clean complete!"

all: check spec
	@echo ""
	@echo "=================================================="
	@echo "✅ All checks passed!"
	@echo "=================================================="

watch:
	@echo "👀 Watching for changes..."
	@which entr > /dev/null || (echo "❌ 'entr' not found. Install with: brew install entr" && exit 1)
	@find 42.13/media/lua spec -name '*.lua' | entr -c make check
