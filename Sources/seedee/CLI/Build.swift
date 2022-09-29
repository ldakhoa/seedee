import Foundation
import ArgumentParser

struct Build: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Build the project")
    
    @Flag(name: .shortAndLong, help: "Build for testing")
    var buildForTesting = false
    
    func run() throws {
        let runner = XCBBuildRunner()
        let arguments = Arguments()
        let stepper = Stepper()
        
        if arguments.actions?.isEmpty ?? true {
            arguments.actions = buildForTesting ? ["build-for-testing"] : ["build"]
        }
        
        if arguments.derivedDataPath?.isEmpty ?? true {
            arguments.derivedDataPath = "DerivedData"
        }
        
        stepper.step(type: .preRun) {
            print("Install dependencies")
        }
        
        stepper.step(type: .run) {
            runner.run(arguments: arguments)
        }
    }
}
