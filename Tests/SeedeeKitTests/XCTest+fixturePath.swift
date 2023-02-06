import XCTest

extension XCTest {
    func fixturePath(for filename: String) -> URL {
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
