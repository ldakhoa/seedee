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
    private let includeDSYMs: Bool?
    private let xcpretty: Bool
    private let quiet: Bool
    private let executor: any Executor

    /// Initializes an instance of `BuildXcodeProjectAction`.
    ///
    /// - Parameters:
    ///   - project: The Xcode project to build.
    ///   - buildConfiguration: The build configuration to use while building the project. Default: nil.
    ///   - destination: The build destination specification. Default: nil.
    ///   - buildForTesting: Should the build be for testing purposes? Default: false.
    ///   - cleanBuild: Should the build be cleaned before execution? Default: false.
    ///   - archivePath: An optional path specifying where the archive should be saved. Default: nil.
    ///   - projectVersion: The project version to use for this build. Default: nil.
    ///   - includeDSYMs: Should the build include dSYM information? Default: nil.
    ///   - xcpretty: Should the output be pipped through `xcpretty`? Default: false.
    ///   - quiet: Should the build process omit unnecessary output? Default: false.
    ///   - executor: The executor to use for running build commands. Default: ProcessExecutor().
    init(
        project: Project,
        buildConfiguration: BuildOptions.BuildConfiguration? = nil,
        destination: BuildOptions.Destination? = nil,
        buildForTesting: Bool = false,
        cleanBuild: Bool = false,
        archivePath: String? = nil,
        projectVersion: String? = nil,
        includeDSYMs: Bool? = nil,
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
        self.includeDSYMs = includeDSYMs
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

        var includeDSYMsFlag: String?

        if let includeDSYMs {
            includeDSYMsFlag = includeDSYMs ? "dwarf-with-dsym" : "dwarf"
        }

        let xcodebuild = CommandBuilder("set -o pipefail && xcodebuild")
            .append(archivePath != nil ? "archive -archivePath \(archivePath!)" : buildCommand)
            .append("-project", value: project.projectPath)
            .append("-workspace", value: project.workspacePath)
            .append("-scheme", value: project.scheme)
            .append("-destination", value: "\'\(destination)\'")
            .append("-configuration", value: buildConfiguration?.settingsValue)
            .append("CURRENT_PROJECT_VERSION", "=", value: projectVersion)
            .append("DEBUG_INFORMATION_FORMAT", "=", value: includeDSYMsFlag)
            .append("clean", flag: cleanBuild)
            .append("| xcpretty", flag: xcpretty)

        return xcodebuild
    }
}

public extension Action {
    /// Builds the Xcode project using the given parameters.
    ///
    /// - Parameters:
    ///   - project: The Xcode project to build.
    ///   - buildConfiguration: The build configuration to use while building the project. Default: nil.
    ///   - destination: The build destination specification. Default: nil.
    ///   - buildForTesting: Should the build be for testing purposes? Default: false.
    ///   - cleanBuild: Should the build be cleaned before execution? Default: false.
    ///   - archivePath: An optional path specifying where the archive should be saved. Default: nil.
    ///   - projectVersion: The project version to use for this build. Default: nil.
    ///   - includeDSYMs: Should the build include dSYM information? Default: nil.
    ///   - xcpretty: Should the output be pipped through `xcpretty`? Default: false.
    ///   - quiet: Should the build process omit unnecessary output? Default: false.
    func buildXcodeProject(
        project: Project,
        buildConfiguration: BuildOptions.BuildConfiguration? = nil,
        destination: BuildOptions.Destination? = nil,
        buildForTesting: Bool = false,
        cleanBuild: Bool = false,
        archivePath: String? = nil,
        projectVersion: String? = nil,
        includeDSYMs: Bool? = nil,
        xcpretty: Bool = false,
        quiet: Bool = false
    ) async throws {
        try await action(
            BuildXcodeProjectAction(
                project: project,
                buildConfiguration: buildConfiguration,
                destination: destination,
                buildForTesting: buildForTesting,
                cleanBuild: cleanBuild,
                archivePath: archivePath,
                projectVersion: projectVersion,
                includeDSYMs: includeDSYMs,
                xcpretty: xcpretty,
                quiet: quiet
            )
        )
    }
}
