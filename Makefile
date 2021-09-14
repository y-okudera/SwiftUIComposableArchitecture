# Variables

## xcodeproj filename
project_name=SwiftUIComposableArchitecture

.PHONY: help
help: ## Show this usage
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: xcode
xcode: ## Select latest version of Xcode
	sudo xcode-select --switch /Applications/Xcode.app/

.PHONY: bootstrap
bootstrap: ## Install tools
	brew bundle
	mint bootstrap

.PHONY: project
project: ## Generate Xcode project and workspace
	mint run SwiftGen swiftgen
	mint run XcodeGen xcodegen

.PHONY: open
open: ## Open Xcode workspace
	open $(project_name).xcodeproj

.PHONY: clean
clean: ## Clean generated files
	rm -rf $(project_name).xcodeproj
	rm -rf $(project_name).xcworkspace
	rm -rf ./**/Generated/*
	rm -rf ~/Library/Developer/Xcode/DerivedData/

.PHONY: update
update: ## Update tool versions
	brew update
	brew upgrade
	mint bootstrap

.PHONY: format
format: ## Reformatting Swift code
	mint run SwiftFormat swiftformat .
