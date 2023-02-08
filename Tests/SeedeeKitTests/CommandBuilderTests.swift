import Foundation
import XCTest
@testable import SeedeeKit

final class CommandBuilderTests: XCTestCase {
    func testCommandBuilder() {
        let builder = CommandBuilder("cd")
            .append("Seedee/Tests/SeedeeKitTests/Resources/Fixtures/IntegrationApp")
            .append("set")
            .append("-o")
            .append("pipefail")
            .append("&&")
            .append("xcodebuild")
            .append("build")
            .append("-project")
            .append("IntegrationApp.xcodeproj")
            .append("-scheme")
            .append("IntegrationApp")
            .append("-destination")
            .append("'platform=iOS Simulator,name=iPhone 8'")
        
        XCTAssertEqual(builder.command, [
            "cd",
            "Seedee/Tests/SeedeeKitTests/Resources/Fixtures/IntegrationApp",
            "set",
            "-o",
            "pipefail",
            "&&",
            "xcodebuild",
            "build",
            "-project",
            "IntegrationApp.xcodeproj",
            "-scheme",
            "IntegrationApp",
            "-destination",
            "'platform=iOS Simulator,name=iPhone 8'"
        ])
    }
}
