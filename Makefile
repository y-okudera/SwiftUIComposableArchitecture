.PHONY: help
help: ## Show this usage
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: xcode
xcode: ## Select latest version of Xcode
	sudo xcode-select --switch /Applications/Xcode.app/

.PHONY: open
open: ## Open Xcode workspace
	open Application/SwiftUIComposableArchitecture.xcodeproj

.PHONY: clean
clean: ## Clean generated files
	rm -rf ./**/Generated/*
	rm -rf ~/Library/Developer/Xcode/DerivedData/

.PHONY: format
format: ## Reformatting Swift code
	mint run SwiftFormat swiftformat .

.PHONY: build-cli-tools
build-cli-tools: # Build CLI tools managed by SwiftPM
	swift build -c release --package-path Application/Tools --product license-plist
	swift build -c release --package-path Application/Tools --product swiftgen
	swift build -c release --package-path Application/Tools --product swiftlint
