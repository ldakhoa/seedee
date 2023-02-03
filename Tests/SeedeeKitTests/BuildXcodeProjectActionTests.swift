import Foundation
import XCTest
@testable import SeedeeKit

private let fixturePath = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .appendingPathComponent("Resources")
    .appendingPathComponent("Fixtures")
private let integrationTestAppPath = fixturePath.appendingPathComponent("IntegrationTestiOSApp")

final class BuildXcodeProjectActionTests: XCTestCase {
    private let fileManager = FileManager.default
    lazy var outputDir = URL(fileURLWithPath: fileManager.currentDirectoryPath).appendingPathComponent("SeedeeOutput")

    func testBuildXcodeProject() async throws {
        // Because IntegrationTestApp is in Tests/Resources/Fixtures,
        // we need to copy it to DerivedData to run test,
        // then delete when finish
        let buildOptions = BuildOptions(buildConfiguration: .debug, sdks: .iOSSimulator)
        let action = BuildXcodeProjectAction(
            project: "IntegrationTestApp.xcodeproj",
            scheme: "IntegrationTestApp",
            buildOptions: buildOptions,
            cleanBuild: true,
            projectVersion: "1.0.0",
            xcbeautify: false
        )
        let output = try await action.run()

        let expectedOutput = """
        xcodebuild build -project testproject.xcodeproj \\
        -scheme testproject -destination generic/platform=iOS Simulator \\
        -configuration Debug CURRENT_PROJECT_VERSION=1.0.0"
        """
        XCTAssertEqual(output, expectedOutput)
    }
}
