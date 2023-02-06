import Foundation
import XCTest
@testable import SeedeeKit

final class TestXcodeProjectActionTests: XCTestCase {

    func test_testXcodeProject() async throws {
        let action = TestXcodeProjectAction(
            project: "IntegrationApp.xcodeproj",
            scheme: "IntegrationApp",
            destination: nil,
            workingDirectory: integrationAppPath.path
        )

        let output = try await action.run()

        XCTAssertEqual(output.contains("** TEST SUCCEEDED **"), true)
    }

    func test_BuildXcodeProject_testWithoutBuildingEnable() async throws {
        let action = TestXcodeProjectAction(
            project: "IntegrationApp.xcodeproj",
            scheme: "IntegrationApp",
            destination: nil,
            testWithoutBuilding: true,
            workingDirectory: integrationAppPath.path
        )
        let output = try await action.run()

        XCTAssertEqual(output.contains("** TEST EXECUTE SUCCEEDED **"), true)
    }

    func test_testXcodeProject_withWorkspace() async throws {
        let path = fixturePath(for: "IntegrationPodApp").path

        try await ShellAction(commandBuilder: CommandBuilder("bundle install"), workingDirectory: path).run()
        try await ShellAction(commandBuilder: CommandBuilder("bundle exec pod install"), workingDirectory: path).run()

        let action = TestXcodeProjectAction(
            workspace: "IntegrationPodApp.xcworkspace",
            scheme: "IntegrationPodApp",
            destination: .custom("platform=iOS Simulator,name=iPhone 8"),
            workingDirectory: path
        )
        let output = try await action.run()

        XCTAssertEqual(output.contains("** TEST SUCCEEDED **"), true)
    }
}
