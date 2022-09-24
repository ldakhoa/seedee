import XCTest
import ArgumentParser

@testable import seedee

final class SeedeeTests: XCTestCase {
    
    func test_seedee_help() throws {
        let helpText = """
        OVERVIEW: A Swift CLI tool to make your CI/CD easier

        USAGE: seedee <subcommand>

        OPTIONS:
          --version               Show the version.
          -h, --help              Show help information.

        SUBCOMMANDS:
          build                   Build the project
          test                    Test the project

          See 'seedee help <subcommand>' for detailed help.
        """
        
        let command = Seedee.helpMessage()
        XCTAssertEqual(command, helpText)
    }
    
    func parse<A>(_ type: A.Type, _ arguments: [String]) throws -> A where A: ParsableCommand {
        return try XCTUnwrap(type.parseAsRoot(arguments) as? A)
    }
   
}
