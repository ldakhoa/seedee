import ArgumentParser

struct Test: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Test the project")
    
    @Flag(name: .shortAndLong, help: "Test without build the project")
    var testWithoutBuilding = false
    
    func run() throws {
        let runner = XCBTestRunner()
        let stepper = Stepper()
        
        let args = Arguments()
        
        if args.actions?.isEmpty ?? true {
            args.actions = testWithoutBuilding ? ["test-without-building"] : ["test"]
        }
        
        stepper.step(type: .preRun) {
            print("Install dependencies")
        }
        
        stepper.step(type: .run) {
            runner.run(arguments: args)
        }
        
    }
}
