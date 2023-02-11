import Foundation
import XCTest
@testable import SeedeeKit

final class TestXcodeProjectActionTests: XCTestCase {
    func test_testXcodeProject_buildShouldSuccess() async throws {
        let project = Project(
            workingDirectory: integrationAppPath,
            projectPath: "IntegrationApp.xcodeproj",
            scheme: "IntegrationApp")

        let action = TestXcodeProjectAction(project: project)

        let result = try await action.run()
        XCTAssertEqual(result.terminationStatus, 0)
        XCTAssertTrue(result.output.lowercased().contains("** test succeeded **"))
    }

    func test_testXcodeProject_buildShouldFail() async throws {
        let project = Project(
            workingDirectory: integrationAppPath,
            projectPath: "IntegrationAppWrongName.xcodeproj",
            scheme: "IntegrationApp")

        let action = TestXcodeProjectAction(project: project)

        do {
            try await action.run()
            XCTFail("It should be fail")
        } catch let error as NSError {
            XCTAssertEqual(error.code, 1)
        }
    }
}
