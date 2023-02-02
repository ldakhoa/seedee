import Foundation
import ArgumentParser

@main
struct Seedee: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A Swift CLI tool to make your CI/CD easier",
        version: "0.0.1",
        subcommands: []
    )
}
