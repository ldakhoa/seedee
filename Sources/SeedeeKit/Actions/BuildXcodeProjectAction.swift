import Foundation

public struct BuildXcodeProjectAction: Action {
    public let name = "Build Xcode Project"

    private let project: String?
    private let workspace: String?
    private let scheme: String?
    private let buildConfiguration: BuildOptions.BuildConfiguration?
    private let destination: BuildOptions.Destination?
    private let buildForTesting: Bool
    private let cleanBuild: Bool
    private let archivePath: String?
    private let projectVersion: String?
    private let xcpretty: Bool
    private let workingDirectory: String?
    private let quiet: Bool

    public init(
        project: String? = nil,
        workspace: String? = nil,
        scheme: String? = nil,
        buildConfiguration: BuildOptions.BuildConfiguration? = nil,
        destination: BuildOptions.Destination? = nil,
        buildForTesting: Bool = false,
        cleanBuild: Bool = false,
        archivePath: String? = nil,
        projectVersion: String? = nil,
        xcpretty: Bool = false,
        workingDirectory: String? = nil,
        quiet: Bool = false
    ) {
        self.project = project
        self.workspace = workspace
        self.scheme = scheme
        self.buildConfiguration = buildConfiguration
        self.destination = destination
        self.buildForTesting = buildForTesting
        self.cleanBuild = cleanBuild
        self.archivePath = archivePath
        self.projectVersion = projectVersion
        self.xcpretty = xcpretty
        self.workingDirectory = workingDirectory
        self.quiet = quiet
    }

    public func run() async throws -> String {
        let defaultDestination = "platform=iOS Simulator,name=iPhone 8"
        let destination = destination?.description ?? defaultDestination

        let buildCommand = buildForTesting ? "build-for-testing" : "build"

        let xcodebuild = CommandBuilder("set -o pipefail && xcodebuild")
            .append(archivePath != nil ? "archive -archivePath \(archivePath!)" : buildCommand)
            .append("-project", value: project)
            .append("-workspace", value: workspace)
            .append("-scheme", value: scheme)
            .append("-destination", value: "\'\(destination)\'")
            .append("-configuration", value: buildConfiguration?.settingsValue)
            .append("CURRENT_PROJECT_VERSION", "=", value: projectVersion)
            .append("clean", flag: cleanBuild)
            .append("| xcpretty", flag: xcpretty)

        return try executor.shell(xcodebuild, workingDirectory: workingDirectory, quiet: quiet)
    }
}

public extension Action {
    @discardableResult
    func buildXcodeProject(
        project: String? = nil,
        workspace: String? = nil,
        scheme: String? = nil,
        buildConfiguration: BuildOptions.BuildConfiguration? = nil,
        destination: BuildOptions.Destination? = nil,
        cleanBuild: Bool = false,
        archivePath: String? = nil
    ) async throws -> String {
        try await action(
            BuildXcodeProjectAction(
                project: project,
                workspace: workspace,
                scheme: scheme,
                buildConfiguration: buildConfiguration,
                destination: destination,
                cleanBuild: cleanBuild,
                archivePath: archivePath
            )
        )
    }
}
