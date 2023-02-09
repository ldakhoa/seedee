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

        let output = try await action.run()
        XCTAssertEqual(output.exitStatus, .terminated(code: 0))
    }
}
