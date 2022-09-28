import Foundation
import ArgumentParser

struct Build: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Build the project")
    
    func run() throws {
        let runner = XCBBuildRunner()
        let args = Arguments()
        if args.actions?.isEmpty ?? true {
            args.actions = ["build"]
        }
        runner.run(arguments: args)
    }
}
