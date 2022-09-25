import Foundation
import ArgumentParser

struct Build: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Build the project")
    
    // The `@OptionGroup` attribute includes the flags, options, and
    // arguments defined by another `ParsableArguments` type.
    @OptionGroup var options: Options
    
    func run() throws {
        let projectMetadata = ProjectMetadata()
        print("Run build command")

        print(projectMetadata.xcodeprojPath)
        print(projectMetadata.projectName!)
        print(projectMetadata.xcworkspacePath!)
    }
}
