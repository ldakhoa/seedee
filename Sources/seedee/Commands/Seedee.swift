import ArgumentParser

@main
public struct Seedee: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "A Swift CLI tool to make your CI/CD easier",
        version: "1.0.0",
        subcommands: [
            Build.self,
            Test.self
        ]
    )
    
    public init() {}
}
