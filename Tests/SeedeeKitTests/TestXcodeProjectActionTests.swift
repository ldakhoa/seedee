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
        let expectation = self.expectation(description: "Build Completed")

        do {
            let result = try await action.run()
            XCTAssertEqual(result.exitStatus, .terminated(code: 0))
            expectation.fulfill()
        } catch {
            XCTFail("Failed to run \(error)")
        }

        await waitForExpectations(timeout: 300)
    }
}
