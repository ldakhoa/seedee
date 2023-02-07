import Foundation
import XCTest
@testable import SeedeeKit

final class BuildXcodeProjectActionTests: XCTestCase {

    func test_buildXcodeProject() async throws {
        let action = BuildXcodeProjectAction(
            project: "IntegrationApp.xcodeproj",
            scheme: "IntegrationApp",
            buildConfiguration: .debug,
            cleanBuild: true,
            workingDirectory: integrationAppPath.path
        )

        let command = try await action.buildCommand()

        let expectedCommand = CommandBuilder("set -o pipefail && xcodebuild build -project IntegrationApp.xcodeproj -scheme IntegrationApp -destination 'platform=iOS Simulator,name=iPhone 8' -configuration Debug clean")

        XCTAssertEqual(command, expectedCommand)
    }

    func test_buildXcodeProject_xcprettyEnable() async throws {
        let action = BuildXcodeProjectAction(
            workspace: "IntegrationPodApp.xcworkspace",
            scheme: "IntegrationPodApp",
            xcpretty: true,
            workingDirectory: fixturePath(for: "IntegrationPodApp").path
        )
        let command = try await action.buildCommand()

        let expectedCommand = CommandBuilder("set -o pipefail && xcodebuild build -workspace IntegrationPodApp.xcworkspace -scheme IntegrationPodApp -destination 'platform=iOS Simulator,name=iPhone 8' | xcpretty")

        XCTAssertEqual(command, expectedCommand)
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

        let command = try await action.buildCommand()

        let expectedCommand = CommandBuilder("set -o pipefail && xcodebuild build-for-testing -project IntegrationApp.xcodeproj -scheme IntegrationApp -destination 'platform=iOS Simulator' -configuration Debug clean")
        XCTAssertEqual(command, expectedCommand)
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
        let command = try await action.buildCommand()

        let expectedCommand = CommandBuilder("set -o pipefail && xcodebuild build -workspace IntegrationPodApp.xcworkspace -scheme IntegrationPodApp -destination 'platform=iOS Simulator,name=iPhone 8' -configuration Debug")

        XCTAssertEqual(command, expectedCommand)
    }
}
