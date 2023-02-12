import Foundation
import XCTest
@testable import SeedeeKit

final class BuildXcodeProjectActionTests: XCTestCase {
    override func setUp() async throws {
        try await super.setUp()
        let action = ShellAction(
            commandBuilder: CommandBuilder("bundle install && bundle exec pod install"),
            workingDirectory: fixturePath(for: "IntegrationPodApp")
        )

        try await action.run()
    }

    func test_buildXcodeProject_buildShouldSuccess() async throws {
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

    func test_buildXcodeProject_buildShouldFail() async throws {
        let project = Project(
            workingDirectory: integrationAppPath,
            projectPath: "IntegrationAppWrongName.xcodeproj",
            scheme: "IntegrationApp")

        let action = BuildXcodeProjectAction(
            project: project,
            buildConfiguration: .debug,
            cleanBuild: true
        )

        do {
            try await action.run()
            XCTFail("It should be fail")
        } catch let error as NSError {
            XCTAssertEqual(error.code, 1)
        }
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
