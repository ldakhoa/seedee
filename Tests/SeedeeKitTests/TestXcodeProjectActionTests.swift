import Foundation
import XCTest
@testable import SeedeeKit

final class TestXcodeProjectActionTests: XCTestCase {
    func test_testXcodeProject() async throws {
        let action = TestXcodeProjectAction(
            workspace: "IntegrationPodApp.xcworkspace",
            scheme: "IntegrationPodApp",
            destination: nil,
            workingDirectory: fixturePath(for: "IntegrationPodApp").path,
            xcpretty: true
        )

        let command = try await action.buildCommand()

        let expectedCommand = CommandBuilder("set -o pipefail && xcodebuild test -workspace IntegrationPodApp.xcworkspace -scheme IntegrationPodApp -destination 'platform=iOS Simulator,name=iPhone 8' | xcpretty")

        XCTAssertEqual(command, expectedCommand)
    }
}
