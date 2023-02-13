import Foundation

/// The metadata that contains `workingDirectory`, `projectPath`, `workspacePath` and `scheme`.
public struct Project {
    /// The working directory URL.
    let workingDirectory: URL

    /// Path to the `.projectPath` file.
    let projectPath: String?

    /// Path to the `.xcworkspace` file.
    let workspacePath: String?

    /// Scheme.
    let scheme: String?

    public init(
        workingDirectory: URL = URL(fileURLWithPath: "."),
        projectPath: String? = nil,
        workspacePath: String? = nil,
        scheme: String? = nil
    ) {
        self.workingDirectory = workingDirectory
        self.projectPath = projectPath
        self.workspacePath = workspacePath
        self.scheme = scheme
    }
}
