// import XCTest
// @testable import SeedeeKit
//
// final class ShellActionTests: XCTestCase {
//    func test_runShell() async throws {
//        let commandBuilder = CommandBuilder("ls")
//
//        let action = ShellAction(commandBuilder: commandBuilder, workingDirectory: integrationAppPath)
//        let result = try await action.run()
//        XCTAssertTrue(result.output.contains("IntegrationApp"))
//        XCTAssertTrue(result.output.contains("IntegrationApp.xcodeproj"))
//        XCTAssertEqual(result.terminationStatus, 0)
//    }
//
//    func test_runShell_fail() async throws {
//        let commandBuilder = CommandBuilder("ll")
//
//        let action = ShellAction(commandBuilder: commandBuilder, workingDirectory: integrationAppPath)
//        do {
//            try await action.run()
//            XCTFail("It should be fail")
//        } catch let error as NSError {
//            XCTAssertEqual(error.code, 1)
//        }
//    }
// }
