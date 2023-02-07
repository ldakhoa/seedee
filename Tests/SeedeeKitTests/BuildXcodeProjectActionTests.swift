import Foundation
import XCTest
@testable import SeedeeKit

final class BuildXcodeProjectActionTests: XCTestCase {

    override class func setUp() {
        super.setUp()

        Task {
            let integrationPodPath = fixturePath(for: "IntegrationPodApp").path

            try await ShellAction(commandBuilder: CommandBuilder("bundle install"), workingDirectory: integrationPodPath).run()
            try await ShellAction(commandBuilder: CommandBuilder("bundle exec pod install"), workingDirectory: integrationPodPath).run()
        }
    }

    func test_buildXcodeProject() async throws {
        let action = BuildXcodeProjectAction(
            project: "IntegrationApp.xcodeproj",
            scheme: "IntegrationApp",
            buildConfiguration: .debug,
            cleanBuild: true,
            xcpretty: false,
            workingDirectory: integrationAppPath.path
        )
        let output = try await action.run()

        XCTAssertEqual(output.contains("** BUILD SUCCEEDED **"), true)
    }

    func test_buildXcodeProject_xcprettyEnable() async throws {
        let action = BuildXcodeProjectAction(
            workspace: "IntegrationPodApp.xcworkspace",
            scheme: "IntegrationPodApp",
            xcpretty: true,
            workingDirectory: fixturePath(for: "IntegrationPodApp").path
        )
        let output = try await action.run()

        XCTAssertEqual(output.contains("Build Succeeded"), true)
    }

    func test_buildXcodeProject_buildForTestingEnable() async throws {
        let action = BuildXcodeProjectAction(
            project: "IntegrationApp.xcodeproj",
            scheme: "IntegrationApp",
            buildConfiguration: .debug,
            destination: .iOSSimulator,
            buildForTesting: true,
            cleanBuild: true,
            workingDirectory: integrationAppPath.path
        )
        let output = try await action.run()

        XCTAssertEqual(output.contains("** TEST BUILD SUCCEEDED **"), true)
    }

    func test_buildXcodeProject_withWorkspace() async throws {
        let path = fixturePath(for: "IntegrationPodApp").path

        let action = BuildXcodeProjectAction(
            workspace: "IntegrationPodApp.xcworkspace",
            scheme: "IntegrationPodApp",
            buildConfiguration: .debug,
            destination: .custom("platform=iOS Simulator,name=iPhone 8"),
            workingDirectory: path
        )
        let output = try await action.run()

        XCTAssertEqual(output.contains("** BUILD SUCCEEDED **"), true)
    }
}
