PROJECT ?= Increment.xcodeproj
SCHEME ?= Increment
CONFIGURATION ?= Debug
DESTINATION ?= platform=iOS Simulator,name=iPhone 17
CODE_COVERAGE ?= YES
REPORT_DIR ?= TestReports
TEST_RUN_ID ?= $(shell date +%Y%m%d-%H%M%S)
RESULT_BUNDLE_PATH ?= $(REPORT_DIR)/$(SCHEME)-$(TEST_RUN_ID).xcresult
TEST_REPORT_PATH ?= $(REPORT_DIR)/$(SCHEME)-$(TEST_RUN_ID).md
SWIFTLINT ?= swiftlint
SWIFTFORMAT ?= swiftformat

define WRITE_TEST_REPORT
mkdir -p "$(REPORT_DIR)"; \
{ \
	echo "# Test Report"; \
	echo ""; \
	echo "- Scheme: $(SCHEME)"; \
	echo "- Destination: $(DESTINATION)"; \
	echo "- Code coverage: $(CODE_COVERAGE)"; \
	echo "- Exit status: $$status"; \
	echo "- Result bundle: $(RESULT_BUNDLE_PATH)"; \
} > "$(TEST_REPORT_PATH)"; \
if [ -d "$(RESULT_BUNDLE_PATH)" ]; then \
	{ echo ""; echo "## Test Summary"; echo '```json'; } >> "$(TEST_REPORT_PATH)"; \
	xcrun xcresulttool get test-results summary --path "$(RESULT_BUNDLE_PATH)" --compact >> "$(TEST_REPORT_PATH)" || echo "Unable to read test summary." >> "$(TEST_REPORT_PATH)"; \
	echo '```' >> "$(TEST_REPORT_PATH)"; \
	{ echo ""; echo "## Tests"; echo '```json'; } >> "$(TEST_REPORT_PATH)"; \
	xcrun xcresulttool get test-results tests --path "$(RESULT_BUNDLE_PATH)" --compact >> "$(TEST_REPORT_PATH)" || echo "Unable to read test list." >> "$(TEST_REPORT_PATH)"; \
	echo '```' >> "$(TEST_REPORT_PATH)"; \
	if [ "$(CODE_COVERAGE)" = "YES" ]; then \
		{ echo ""; echo "## Coverage"; echo '```text'; } >> "$(TEST_REPORT_PATH)"; \
		xcrun xccov view --report "$(RESULT_BUNDLE_PATH)" >> "$(TEST_REPORT_PATH)" || echo "Unable to read coverage report." >> "$(TEST_REPORT_PATH)"; \
		echo '```' >> "$(TEST_REPORT_PATH)"; \
	fi; \
else \
	{ echo ""; echo "No result bundle was found, so no Xcode test details could be reported."; } >> "$(TEST_REPORT_PATH)"; \
fi; \
echo "Test report written to $(TEST_REPORT_PATH)"
endef

.PHONY: help build test test-unit test-ui test-report lint format format-lint clean resolve-packages show-settings open

help:
	@echo "Available targets:"
	@echo "  make build             Build $(SCHEME) in $(CONFIGURATION)"
	@echo "  make test              Run all tests"
	@echo "  make test-unit         Run IncrementTests"
	@echo "  make test-ui           Run IncrementUITests"
	@echo "  make test-report       Generate a report from RESULT_BUNDLE_PATH"
	@echo "  make lint              Run SwiftLint"
	@echo "  make format            Run SwiftFormat"
	@echo "  make format-lint       Run SwiftFormat, then SwiftLint"
	@echo "  make clean             Clean build artifacts"
	@echo "  make resolve-packages  Resolve Swift package dependencies"
	@echo "  make show-settings     Show Xcode build settings"
	@echo "  make open              Open the Xcode project"
	@echo ""
	@echo "Overrides:"
	@echo "  make test DESTINATION='platform=iOS Simulator,name=iPhone 17'"
	@echo "  make test CODE_COVERAGE=NO"
	@echo "  make test REPORT_DIR=Reports"
	@echo "  make build CONFIGURATION=Release"

build:
	xcodebuild -project "$(PROJECT)" -scheme "$(SCHEME)" -configuration "$(CONFIGURATION)" build

test:
	@mkdir -p "$(REPORT_DIR)"
	@status=0; \
	xcodebuild test -project "$(PROJECT)" -scheme "$(SCHEME)" -destination "$(DESTINATION)" -enableCodeCoverage "$(CODE_COVERAGE)" -resultBundlePath "$(RESULT_BUNDLE_PATH)" || status=$$?; \
	$(WRITE_TEST_REPORT); \
	exit $$status

test-unit:
	@mkdir -p "$(REPORT_DIR)"
	@status=0; \
	xcodebuild test -project "$(PROJECT)" -scheme "$(SCHEME)" -only-testing:IncrementTests -destination "$(DESTINATION)" -enableCodeCoverage "$(CODE_COVERAGE)" -resultBundlePath "$(RESULT_BUNDLE_PATH)" || status=$$?; \
	$(WRITE_TEST_REPORT); \
	exit $$status

test-ui:
	@mkdir -p "$(REPORT_DIR)"
	@status=0; \
	xcodebuild test -project "$(PROJECT)" -scheme "$(SCHEME)" -only-testing:IncrementUITests -destination "$(DESTINATION)" -enableCodeCoverage "$(CODE_COVERAGE)" -resultBundlePath "$(RESULT_BUNDLE_PATH)" || status=$$?; \
	$(WRITE_TEST_REPORT); \
	exit $$status

test-report:
	@status="$(TEST_EXIT_STATUS)"; \
	$(WRITE_TEST_REPORT)

lint:
	$(SWIFTLINT) lint --config .swiftlint.yml

format:
	$(SWIFTFORMAT) . --config .swiftformat

format-lint: format lint

clean:
	xcodebuild clean -project "$(PROJECT)" -scheme "$(SCHEME)" -configuration "$(CONFIGURATION)"

resolve-packages:
	xcodebuild -resolvePackageDependencies -project "$(PROJECT)" -scheme "$(SCHEME)"

show-settings:
	xcodebuild -showBuildSettings -project "$(PROJECT)" -scheme "$(SCHEME)" -configuration "$(CONFIGURATION)"

open:
	open "$(PROJECT)"
