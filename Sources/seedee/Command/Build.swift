import ArgumentParser

struct Build: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Build the project")
    
    // The `@OptionGroup` attribute includes the flags, options, and
    // arguments defined by another `ParsableArguments` type.
    @OptionGroup var options: Options
    
    func run() throws {
        print("Run build command")
        print("build command with \(options.buildForTesting)")
    }
}

struct Options: ParsableArguments {
    @Flag(name: [.long], help: "")
    var buildForTesting: Bool = false
    
    @Flag(name: [.long], help: "")
    var testWithoutBuilding: Bool = false
}
