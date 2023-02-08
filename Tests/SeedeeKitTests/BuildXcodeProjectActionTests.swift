import Foundation
import XCTest
@testable import SeedeeKit

final class BuildXcodeProjectActionTests: XCTestCase {
    func test_buildXcodeProject() async throws {
        let project = Project(
            workingDirectory: integrationAppPath,
            projectPath: "IntegrationApp.xcodeproj",
            scheme: "IntegrationApp")

        let action = BuildXcodeProjectAction(
            project: project,
            buildConfiguration: .debug,
            cleanBuild: true
        )

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

    func test_buildXcodeProject_xcprettyEnable() async throws {
        let project = Project(
            workingDirectory: fixturePath(for: "IntegrationPodApp"),
            workspacePath: "IntegrationPodApp.xcworkspace",
            scheme: "IntegrationPodApp")

        let action = BuildXcodeProjectAction(
            project: project,
            buildConfiguration: .debug,
            xcpretty: true
        )

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

    func test_buildXcodeProject_buildForTestingEnable() async throws {
        let project = Project(
            workingDirectory: fixturePath(for: "IntegrationPodApp"),
            workspacePath: "IntegrationPodApp.xcworkspace",
            scheme: "IntegrationPodApp")

        let action = BuildXcodeProjectAction(
            project: project,
            buildConfiguration: .debug,
            buildForTesting: true,
            xcpretty: true
        )

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
