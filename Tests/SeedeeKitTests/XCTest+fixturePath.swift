import XCTest

// Refactor this using Singleton to avoid call `setUp()` every single test case
extension XCTest {
    func fixturePath(for filename: String) -> URL {
        let fixturePath = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent("Resources")
            .appendingPathComponent("Fixtures")
        return fixturePath.appendingPathComponent(filename)
    }

    static func fixturePath(for filename: String) -> URL {
        let fixturePath = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent("Resources")
            .appendingPathComponent("Fixtures")
        return fixturePath.appendingPathComponent(filename)
    }

    var integrationAppPath: URL {
        fixturePath(for: "IntegrationApp")
    }
}
