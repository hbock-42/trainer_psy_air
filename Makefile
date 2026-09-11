FLUTTER ?= flutter
DART    ?= dart

.PHONY: help deps gen gen-watch lint format test run run-macos run-web build-macos build-web clean board
.PHONY: help deps gen gen-watch lint format test test-watch coverage run clean board

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'

deps: ## Fetch packages
	$(FLUTTER) pub get

gen: deps ## Run code generation (freezed, json_serializable, drift)
	$(DART) run build_runner build --delete-conflicting-outputs

gen-watch: deps ## Run code generation in watch mode
	$(DART) run build_runner watch --delete-conflicting-outputs

lint: deps ## Static analysis and formatting check
	$(FLUTTER) analyze
	$(DART) format --output=none --set-exit-if-changed lib test tool

format: ## Format Dart sources
	$(DART) format lib test tool

test: deps ## Run all tests
	$(FLUTTER) test

test-watch: deps ## Re-run tests whenever a Dart file changes (needs fswatch or entr)
	@if command -v entr >/dev/null 2>&1; then \
		while true; do find lib test tool -name '*.dart' | entr -d $(FLUTTER) test; done; \
	elif command -v fswatch >/dev/null 2>&1; then \
		$(FLUTTER) test; fswatch -o lib test tool | xargs -n1 -I{} $(FLUTTER) test; \
	else \
		echo "Install entr (brew install entr) or fswatch to use test-watch"; exit 1; \
	fi

coverage: deps ## Run tests with coverage and enforce the 70 % gate on domain/data/core
	$(FLUTTER) test --coverage
	$(DART) run tool/coverage_gate.dart --min 70

run: deps ## Run the app on the connected device (DEVICE=<id> to pick one)
	$(FLUTTER) run $(if $(DEVICE),-d $(DEVICE),)

run-macos: deps ## Run the desktop app on macOS
	$(FLUTTER) run -d macos

run-web: deps ## Run the web app in Chrome
	$(FLUTTER) run -d chrome

build-macos: deps ## Debug build of the macOS app (headless verification)
	$(FLUTTER) build macos --debug

build-web: deps ## Release build of the web app (same command as CI)
	$(FLUTTER) build web --release

clean: ## Remove build artefacts
	$(FLUTTER) clean

board: ## Regenerate docs/kanban/BOARD.md
	docs/kanban/gen_board.sh
