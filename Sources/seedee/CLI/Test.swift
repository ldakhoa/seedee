import ArgumentParser

struct Test: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Test the project")
    
    func run() throws {
        print("Run test command")
    }
}
