build:
	swift build -v

test:
	swift test -v

test.integration.ios:
	sh scripts/integration_test_ios.sh
