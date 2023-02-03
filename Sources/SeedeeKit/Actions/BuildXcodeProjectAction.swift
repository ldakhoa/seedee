import Foundation

public struct BuildXcodeProjectAction: Action {
    public let name = "Build Xcode Project"

    let project: String?
    let scheme: String?
    let buildOptions: BuildOptions?
    let cleanBuild: Bool
    let archivePath: String?
    let projectVersion: String?
    let xcbeautify: Bool

    init(
        project: String? = nil,
        scheme: String? = nil,
        buildOptions: BuildOptions?,
        cleanBuild: Bool = false,
        archivePath: String? = nil,
        projectVersion: String? = nil,
        xcbeautify: Bool = false
    ) {
        self.project = project
        self.scheme = scheme
        self.buildOptions = buildOptions
        self.cleanBuild = cleanBuild
        self.archivePath = archivePath
        self.projectVersion = projectVersion
        self.xcbeautify = xcbeautify
    }

    public func run() async throws -> String {
        let xcodebuild = CommandBuilder("xcodebuild")
            .append(archivePath != nil ? "archive -archivePath \(archivePath!)" : "build")
            .append("-project", value: project)
            .append("-scheme", value: scheme)
            .append("-destination", value: buildOptions?.sdk.destination)
            .append("-configuration", value: buildOptions?.buildConfiguration.settingsValue)
            .append("CURRENT_PROJECT_VERSION", "=", value: projectVersion)

        return try executor.shell(xcodebuild)
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
