FLUTTER ?= flutter
DART    ?= dart
APP     := apps/psy_trainer
CONTENT := packages/psy_content

# US-007: monorepo (pub workspace) root. `deps` resolves every member from
# the single pubspec.lock here; everything else delegates to the app
# package, the psy_content package or the repo-wide tools/ scripts.
# See docs/ARCHITECTURE.md ("Repository layout") for the full picture, and
# melos.yaml for the same commands as Melos scripts (`melos run <name>`) if
# you'd rather use that.

.PHONY: help deps gen gen-watch lint format test test-watch coverage content-check content-assets run run-macos run-web build-macos build-web clean board

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'

deps: ## Fetch packages for the whole workspace (single pubspec.lock)
	$(DART) pub get

gen: deps ## Run code generation (freezed, json_serializable) for the app and psy_content
	(cd $(APP) && $(DART) run build_runner build --delete-conflicting-outputs)
	(cd $(CONTENT) && $(DART) run build_runner build --delete-conflicting-outputs)

gen-watch: deps ## Run code generation in watch mode for the app
	(cd $(APP) && $(DART) run build_runner watch --delete-conflicting-outputs)

lint: deps ## Static analysis and formatting check, every package
	(cd $(APP) && $(FLUTTER) analyze --fatal-infos)
	(cd $(CONTENT) && $(DART) analyze --fatal-infos)
	$(DART) format --output=none --set-exit-if-changed $(APP)/lib $(APP)/test tools
	$(DART) format --output=none --set-exit-if-changed $(CONTENT)/lib $(CONTENT)/test $(CONTENT)/bin

format: ## Format Dart sources in every package
	$(DART) format $(APP)/lib $(APP)/test tools
	$(DART) format $(CONTENT)/lib $(CONTENT)/test $(CONTENT)/bin

test: deps ## Run every package's tests (app, psy_content, tools/test)
	(cd $(APP) && $(FLUTTER) test)
	(cd $(CONTENT) && $(DART) test)
	$(DART) test tools/test

test-watch: deps ## Re-run the app's tests whenever a Dart file changes (needs fswatch or entr)
	@if command -v entr >/dev/null 2>&1; then \
		while true; do find $(APP)/lib $(APP)/test -name '*.dart' | entr -d sh -c 'cd $(APP) && $(FLUTTER) test'; done; \
	elif command -v fswatch >/dev/null 2>&1; then \
		(cd $(APP) && $(FLUTTER) test); fswatch -o $(APP)/lib $(APP)/test | xargs -n1 -I{} sh -c 'cd $(APP) && $(FLUTTER) test'; \
	else \
		echo "Install entr (brew install entr) or fswatch to use test-watch"; exit 1; \
	fi

coverage: deps ## Run the app's tests with coverage and enforce the 70 % gate on domain/data/core
	(cd $(APP) && $(FLUTTER) test --coverage)
	$(DART) run tools/coverage_gate.dart --file $(APP)/coverage/lcov.info --min 70

content-check: deps ## Validate the content bundle (PATHS=<files or dirs>, default the app's assets/content)
	$(DART) run --verbosity=error psy_content:validate_content $(if $(PATHS),$(PATHS),$(APP)/assets/content)

content-assets: ## Rewrite the app's assets/content folder list in its pubspec.yaml (US-013)
	$(DART) run --verbosity=error tools/list_content_assets.dart --write

run: deps ## Run the app on the connected device (DEVICE=<id> to pick one)
	(cd $(APP) && $(FLUTTER) run $(if $(DEVICE),-d $(DEVICE),))

run-macos: deps ## Run the desktop app on macOS
	(cd $(APP) && $(FLUTTER) run -d macos)

run-web: deps ## Run the web app in Chrome
	(cd $(APP) && $(FLUTTER) run -d chrome)

build-macos: deps ## Debug build of the macOS app (headless verification)
	(cd $(APP) && $(FLUTTER) build macos --debug)

build-web: deps ## Release build of the web app (same command as CI)
	(cd $(APP) && $(FLUTTER) build web --release)

clean: ## Remove build artefacts
	(cd $(APP) && $(FLUTTER) clean)

board: ## Regenerate docs/kanban/BOARD.md
	docs/kanban/gen_board.sh
