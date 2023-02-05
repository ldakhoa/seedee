import Foundation

public struct BuildXcodeProjectAction: Action {
    public let name = "Build Xcode Project"

    private let project: String?
    private let scheme: String?
    private let buildOptions: BuildOptions?
    private let cleanBuild: Bool
    private let archivePath: String?
    private let projectVersion: String?
    private let xcbeautify: Bool
    private let workingDirectory: String?
    private let quiet: Bool

    public init(
        project: String? = nil,
        scheme: String? = nil,
        buildOptions: BuildOptions? = nil,
        cleanBuild: Bool = false,
        archivePath: String? = nil,
        projectVersion: String? = nil,
        xcbeautify: Bool = false,
        workingDirectory: String? = nil,
        quiet: Bool = false
    ) {
        self.project = project
        self.scheme = scheme
        self.buildOptions = buildOptions
        self.cleanBuild = cleanBuild
        self.archivePath = archivePath
        self.projectVersion = projectVersion
        self.xcbeautify = xcbeautify
        self.workingDirectory = workingDirectory
        self.quiet = quiet
    }

    public func run() async throws -> String {
        let defaultDestination = "platform=iOS Simulator,name=iPhone 14"
        let destination = buildOptions?.sdk.destination ?? defaultDestination

        let xcodebuild = CommandBuilder("xcodebuild")
            .append(archivePath != nil ? "archive -archivePath \(archivePath!)" : "build")
            .append("-project", value: project)
            .append("-scheme", value: scheme)
            .append("-destination", value: "\'\(destination)\'")
            .append("-configuration", value: buildOptions?.buildConfiguration.settingsValue)
            .append("CURRENT_PROJECT_VERSION", "=", value: projectVersion)
            .append("clean", flag: cleanBuild)

        return try executor.shell(xcodebuild, workingDirectory: workingDirectory, quiet: quiet)
    }
}

public extension Action {
    @discardableResult
    func buildXcodeProject(
        project: String? = nil,
        scheme: String? = nil,
        buildOptions: BuildOptions? = nil,
        cleanBuild: Bool = false,
        archivePath: String? = nil
    ) async throws -> String {
        try await action(
            BuildXcodeProjectAction(
                project: project,
                scheme: scheme,
                buildOptions: buildOptions,
                cleanBuild: cleanBuild,
                archivePath: archivePath
            )
        )
    }
}
