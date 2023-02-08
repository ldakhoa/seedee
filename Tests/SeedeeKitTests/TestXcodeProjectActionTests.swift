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
        let executor = ProcessExecutor()

        let expectation = self.expectation(description: "Build Completed")

        do {
            let command = try await action.buildCommand().command
            let output = try await executor.execute(command)
            print(try output.unwrapOutput())
            expectation.fulfill()
        } catch {
            XCTFail("Failed to run \(error)")
        }

        await waitForExpectations(timeout: 300)
    }
}
