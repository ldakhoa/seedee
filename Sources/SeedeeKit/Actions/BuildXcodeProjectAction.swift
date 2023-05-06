import Foundation

struct BuildXcodeProjectAction: Action {
    let name = "Build Xcode Project"

    private let project: Project
    private let buildConfiguration: BuildOptions.BuildConfiguration?
    private let destination: BuildOptions.Destination?
    private let buildForTesting: Bool
    private let cleanBuild: Bool
    private let archivePath: String?
    private let projectVersion: String?
    private let xcpretty: Bool
    private let quiet: Bool
    private let executor: any Executor

    init(
        project: Project,
        buildConfiguration: BuildOptions.BuildConfiguration? = nil,
        destination: BuildOptions.Destination? = nil,
        buildForTesting: Bool = false,
        cleanBuild: Bool = false,
        archivePath: String? = nil,
        projectVersion: String? = nil,
        xcpretty: Bool = false,
        quiet: Bool = false,
        executor: any Executor = ProcessExecutor()
    ) {
        self.project = project
        self.buildConfiguration = buildConfiguration
        self.destination = destination
        self.buildForTesting = buildForTesting
        self.cleanBuild = cleanBuild
        self.archivePath = archivePath
        self.projectVersion = projectVersion
        self.xcpretty = xcpretty
        self.quiet = quiet
        self.executor = executor
    }

    @discardableResult
    func run() async throws -> ExecutorResult {
        let buildCommand = try await buildCommand().command
        return try await executor.execute(buildCommand, workingDirectory: project.workingDirectory)
    }

    func buildCommand() async throws -> CommandBuilder {
        let defaultDestination = "platform=iOS Simulator,name=iPhone 8"
        let destination = destination?.description ?? defaultDestination

        let buildCommand = buildForTesting ? "build-for-testing" : "build"

        let xcodebuild = CommandBuilder("set -o pipefail && xcodebuild")
            .append(archivePath != nil ? "archive -archivePath \(archivePath!)" : buildCommand)
            .append("-project", value: project.projectPath)
            .append("-workspace", value: project.workspacePath)
            .append("-scheme", value: project.scheme)
            .append("-destination", value: "\'\(destination)\'")
            .append("-configuration", value: buildConfiguration?.settingsValue)
            .append("CURRENT_PROJECT_VERSION", "=", value: projectVersion)
            .append("clean", flag: cleanBuild)
            .append("| xcpretty", flag: xcpretty)

        return xcodebuild
    }
}

public extension Action {
    func buildXcodeProject(
        project: Project,
        buildConfiguration: BuildOptions.BuildConfiguration? = nil,
        destination: BuildOptions.Destination? = nil,
        cleanBuild: Bool = false,
        archivePath: String? = nil
    ) async throws {
        try await action(
            BuildXcodeProjectAction(
                project: project,
                buildConfiguration: buildConfiguration,
                destination: destination,
                cleanBuild: cleanBuild,
                archivePath: archivePath
            )
        )
    }
}
