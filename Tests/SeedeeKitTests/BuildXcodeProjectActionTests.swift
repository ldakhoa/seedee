import Foundation
import XCTest
@testable import SeedeeKit

final class BuildXcodeProjectActionTests: XCTestCase {
    override func setUp() async throws {
        try await super.setUp()

        if shouldSetUpCocoaPods {
            let action = ShellAction(
                commandBuilder: CommandBuilder("bundle install && bundle exec pod install"),
                workingDirectory: fixturePath(for: "IntegrationPodApp")
            )
            try await action.run()
        }
    }

    var shouldSetUpCocoaPods: Bool {
        if let value = ProcessInfo.processInfo.environment["SHOULD_SETUP_COCOAPODS"], !value.isEmpty {
            return true
        }
        return false
    }

    func test_buildXcodeProject_buildShouldSuccess() async throws {
        let project = Project(
            workingDirectory: integrationAppPath,
            projectPath: "IntegrationApp.xcodeproj",
            scheme: "IntegrationApp")

        let action = BuildXcodeProjectAction(
            project: project,
            buildConfiguration: .debug,
            cleanBuild: true,
            projectVersion: "1.0.0"
        )

        let result = try await action.run()
        XCTAssertEqual(result.terminationStatus, 0)
        XCTAssertFalse(result.output.contains("GenerateDSYMFile"))
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
            XCTFail("Test should be failed")
        } catch let error as NSError {
            XCTAssertEqual(error.code, 1)
        }
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

        let result = try await action.run()

        XCTAssertEqual(result.terminationStatus, 0)
        XCTAssertTrue(result.output.contains("Build Succeeded"))
    }

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

    func test_buildXcodeProject_includeDSYMsIsTrue() async throws {
        let project = Project(
            workingDirectory: integrationAppPath,
            projectPath: "IntegrationApp.xcodeproj",
            scheme: "IntegrationApp")

        let action = BuildXcodeProjectAction(
            project: project,
            buildConfiguration: .debug,
            cleanBuild: true,
            includeDSYMs: true
        )

        let result = try await action.run()

        XCTAssertEqual(result.terminationStatus, 0)
        XCTAssertTrue(result.output.lowercased().contains("build succeeded"))

        // TODO: Should check if contains `AppName.app.dSYM`
        XCTAssertTrue(result.output.contains("GenerateDSYMFile"))
    }

    func test_buildXcodeProject_includeDSYMsIsFalse() async throws {
        let project = Project(
            workingDirectory: integrationAppPath,
            projectPath: "IntegrationApp.xcodeproj",
            scheme: "IntegrationApp")

        let action = BuildXcodeProjectAction(
            project: project,
            buildConfiguration: .debug,
            includeDSYMs: false
        )

        let result = try await action.run()
        XCTAssertEqual(result.terminationStatus, 0)
        XCTAssertTrue(result.output.lowercased().contains("build succeeded"))

        // TODO: Should check if contains `AppName.app.dSYM`
        XCTAssertFalse(result.output.contains("GenerateDSYMFile"))
    }
}
