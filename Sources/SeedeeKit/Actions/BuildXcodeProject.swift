import Foundation

public struct BuildXcodeProject: Action {
    public let name = "Build Xcode Project"

    let project: String?
    let scheme: String?
    let buildOptions: BuildOptions?
    let cleanBuild: Bool
    let archivePath: String?

    init(
        project: String? = nil,
        scheme: String? = nil,
        buildOptions: BuildOptions?,
        cleanBuild: Bool = false,
        archivePath: String? = nil
    ) {
        self.project = project
        self.scheme = scheme
        self.buildOptions = buildOptions
        self.cleanBuild = cleanBuild
        self.archivePath = archivePath
    }

    public func run() async throws -> String {
        let xcodebuild = CommandBuilder("xcodebuild")
            .append("-project")
            .append("-scheme", value: scheme)
            .append("-destination")
            .build()
        print(xcodebuild)
        return ""
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
            BuildXcodeProject(
                project: project,
                scheme: scheme,
                buildOptions: buildOptions,
                cleanBuild: cleanBuild,
                archivePath: archivePath
            )
        )
    }
}
