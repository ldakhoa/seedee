import Foundation
import XCTest
@testable import SeedeeKit

final class TestXcodeProjectActionTests: XCTestCase {
    func test_testXcodeProject() async throws {
        let project = Project(
            workingDirectory: integrationAppPath,
            projectPath: "IntegrationApp.xcodeproj",
            scheme: "IntegrationApp")

        let action = TestXcodeProjectAction(project: project)

        let result = try await action.run()
        print(result.output)
        XCTAssertEqual(result.terminationStatus, 0)
        XCTAssertTrue(result.output.lowercased().contains("** test succeeded **"))
    }
}
