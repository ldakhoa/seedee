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

        let result = try await action.run()
        XCTAssertEqual(result.terminationStatus, 0)
    }

//    func test_buildXcodeProject_xcprettyEnable() async throws {
//        let project = Project(
//            workingDirectory: fixturePath(for: "IntegrationPodApp"),
//            workspacePath: "IntegrationPodApp.xcworkspace",
//            scheme: "IntegrationPodApp")
//
//        let action = BuildXcodeProjectAction(
//            project: project,
//            buildConfiguration: .debug,
//            xcpretty: true
//        )
//
//        let result = try await action.run()
//        print(result.output)
//        XCTAssertEqual(result.terminationStatus, 0)
//    }

    func test_buildXcodeProject_buildForTestingEnable() async throws {
        let project = Project(
            workingDirectory: fixturePath(for: "IntegrationPodApp"),
            workspacePath: "IntegrationPodApp.xcworkspace",
            scheme: "IntegrationPodApp")

        let action = BuildXcodeProjectAction(
            project: project,
            buildConfiguration: .debug,
            buildForTesting: true
        )

        let result = try await action.run()

        XCTAssertEqual(result.terminationStatus, 0)
        XCTAssertTrue(result.output.contains("** TEST BUILD SUCCEEDED **"))
    }
}
