import ArgumentParser

struct Test: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Test the project")
    
    @Flag(name: .shortAndLong, help: "Test without build the project")
    var testWithoutBuild = false
    
    func run() throws {
        print("Run test command")
        let runner = XCBTestRunner()
        let args = Args()
        runner.run(argument: args)
    }
}
