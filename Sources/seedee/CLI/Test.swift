import ArgumentParser

struct Test: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Test the project")
    
    @Flag(name: .shortAndLong, help: "Test without build the project")
    var testWithoutBuilding = false

    @Flag(name: .shortAndLong, help: "Run pod install beforehand")
    var cocoapods = false
    
    func run() throws {
        let runner = XCBTestRunner()
        let podsRunner = CocoaPodsRunner()
        
        let stepper = Stepper()
        
        let args = Arguments()
        
        if args.actions?.isEmpty ?? true {
            args.actions = testWithoutBuilding ? ["test-without-building"] : ["test"]
        }
        
        if cocoapods {
            stepper.step(type: .preRun) {
                podsRunner.prepareCocoaPods(options: .install)
            }
        }
        
        stepper.step(type: .run) {
            runner.run(arguments: args)
        }
        
    }
}
