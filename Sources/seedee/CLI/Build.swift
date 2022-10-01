import Foundation
import ArgumentParser

struct Build: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Build the project")
    
    @Flag(name: .shortAndLong, help: "Build for testing")
    var buildForTesting = false
    
    @Flag(name: .shortAndLong, help: "Run pod install beforehand")
    var cocoapods = false
    
    func run() throws {
        let runner = XCBBuildRunner()
        let podsRunner = CocoaPodsRunner()
        
        let arguments = Arguments()
        let stepper = Stepper()
        
        if arguments.actions?.isEmpty ?? true {
            arguments.actions = buildForTesting ? ["build-for-testing"] : ["build"]
        }
        
        if arguments.derivedDataPath?.isEmpty ?? true {
            arguments.derivedDataPath = "DerivedData"
        }
        
        if cocoapods {
            stepper.step(type: .preRun) {
                podsRunner.prepareCocoaPods(options: .install)
            }
        }

        stepper.step(type: .run) {
            runner.run(arguments: arguments)
        }
    }
}
