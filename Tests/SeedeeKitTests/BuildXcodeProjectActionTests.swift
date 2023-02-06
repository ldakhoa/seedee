import Foundation
import XCTest
@testable import SeedeeKit

final class BuildXcodeProjectActionTests: XCTestCase {
    
    func test_buildXcodeProject() async throws {
        let action = BuildXcodeProjectAction(
            project: "IntegrationApp.xcodeproj",
            scheme: "IntegrationApp",
            buildConfiguration: .debug,
            destination: .iOSSimulator,
            cleanBuild: true,
            xcbeautify: false,
            workingDirectory: integrationAppPath.path
        )
        let output = try await action.run()

        XCTAssertEqual(output.contains("** BUILD SUCCEEDED **"), true)
    }

    func test_buildXcodeProject_buildForTestingEnable() async throws {
        let action = BuildXcodeProjectAction(
            project: "IntegrationApp.xcodeproj",
            scheme: "IntegrationApp",
            buildConfiguration: .debug,
            destination: .iOSSimulator,
            buildForTesting: true,
            cleanBuild: true,
            xcbeautify: false,
            workingDirectory: integrationAppPath.path
        )
        let output = try await action.run()

        XCTAssertEqual(output.contains("** TEST BUILD SUCCEEDED **"), true)
    }

    func test_buildXcodeProject_withWorkspace() async throws {
        let path = fixturePath(for: "IntegrationPodApp").path

        try await ShellAction(commandBuilder: CommandBuilder("bundle install"), workingDirectory: path).run()
        try await ShellAction(commandBuilder: CommandBuilder("bundle exec pod install"), workingDirectory: path).run()

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
