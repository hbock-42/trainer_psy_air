FLUTTER ?= flutter
DART    ?= dart

.PHONY: help deps gen gen-watch lint format test run clean board

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
	$(DART) format --output=none --set-exit-if-changed lib test

format: ## Format Dart sources
	$(DART) format lib test

test: deps ## Run all tests
	$(FLUTTER) test

run: deps ## Run the app on the connected device (DEVICE=<id> to pick one)
	$(FLUTTER) run $(if $(DEVICE),-d $(DEVICE),)

clean: ## Remove build artefacts
	$(FLUTTER) clean

board: ## Regenerate docs/kanban/BOARD.md
	docs/kanban/gen_board.sh
