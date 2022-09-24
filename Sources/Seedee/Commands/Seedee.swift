import ArgumentParser

@main
struct Seedee: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A Swift CLI tool to make your CI/CD easier",
        version: "1.0.0",
        subcommands: [
            Build.self,
            Test.self
        ]
    )
}
