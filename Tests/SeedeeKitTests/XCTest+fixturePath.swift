import XCTest

// Refactor this using Singleton to avoid call `setUp()` every single test case
extension XCTest {
    func fixturePath(for filename: String) -> URL {
        resourcesPath
            .appendingPathComponent("Fixtures")
            .appendingPathComponent(filename)
    }

    var resourcesPath: URL {
        URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent("Resources")
    }

    var integrationAppPath: URL {
        fixturePath(for: "IntegrationApp")
    }
}

extension XCTest {
    var skipUnitTest: Bool {
        if let value = ProcessInfo.processInfo.environment["SKIP_UNIT_TEST"], !value.isEmpty {
            return true
        }
        return false
    }
}
