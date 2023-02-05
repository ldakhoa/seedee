import Foundation
import XCTest
@testable import SeedeeKit

private let fixturePath = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .appendingPathComponent("Resources")
    .appendingPathComponent("Fixtures")
private let integrationAppPath = fixturePath.appendingPathComponent("IntegrationApp")

final class BuildXcodeProjectActionTests: XCTestCase {
    private var buildOptions: BuildOptions!

    override func setUp() {
        super.setUp()
        buildOptions = BuildOptions(buildConfiguration: .debug, sdks: .iOSSimulator)
    }

    func test_BuildXcodeProject() async throws {
        let action = BuildXcodeProjectAction(
            project: "IntegrationApp.xcodeproj",
            scheme: "IntegrationApp",
            buildOptions: buildOptions,
            cleanBuild: true,
            xcbeautify: false,
            workingDirectory: integrationAppPath.path
        )
        let output = try await action.run()

        XCTAssertEqual(output.contains("** BUILD SUCCEEDED **"), true)
    }
}
