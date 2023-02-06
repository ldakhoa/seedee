import Foundation
import XCTest
@testable import SeedeeKit

final class TestXcodeProjectActionTests: XCTestCase {
    func test_testXcodeProject() async throws {
        let action = TestXcodeProjectAction(
            project: "IntegrationApp.xcodeproj",
            scheme: "IntegrationApp",
            destination: nil,
            workingDirectory: integrationAppPath.path
        )

        let output = try await action.run()

        XCTAssertEqual(output.contains("** TEST SUCCEEDED **"), true)
    }
}
