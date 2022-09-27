import Foundation
import ArgumentParser

struct Build: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Build the project")
    
    // The `@OptionGroup` attribute includes the flags, options, and
    // arguments defined by another `ParsableArguments` type.
    @OptionGroup var options: Options
    
    func run() throws {
        let runner = XCBBuildRunner()
        let args = Args()
        runner.run(argument: args)
    }
}
