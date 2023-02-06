import Foundation
import XCTest
@testable import SeedeeKit

final class TestXcodeProjectActionTests: XCTestCase {
    private var buildOptions: BuildOptions!

    override func setUp() {
        super.setUp()
        buildOptions = BuildOptions(buildConfiguration: .debug, sdks: .iOSSimulator)
    }

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
}
