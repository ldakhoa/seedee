import Foundation

public struct BuildSettings {
    /// All build settings given at intialization.
    let settings: [String: String]

    enum Error: Swift.Error, LocalizedError {
        case missingBuildSetting(key: String)

        var errorDescription: String? {
            switch self {
            case let .missingBuildSetting(key):
                return "xcodebuild did not return a value for build setting \(key)"
            }
        }
    }

    /// Initialize an instance of `BuildSettings` using the Xcode project path and, optionally, the scheme name.
    ///
    /// - Parameters:
    ///   - xcodeProjectPath: The path to the Xcode project.
    ///   - scheme: The scheme to use for build settings. If `scheme` is not specified, the default scheme is used.
    public init(
        xcodeProjectPath: String,
        scheme: String? = nil,
        workingDirectory: URL? = nil,
        buildConfiguration: BuildOptions.BuildConfiguration? = nil
    ) async throws {
        let command = CommandBuilder("xcodebuild")
            .append("-project", value: xcodeProjectPath)
            .append("-scheme", value: scheme)
            .append("-showBuildSettings")
            .append("-configuration", value: buildConfiguration?.settingsValue)
        // TODO: Avoid force unwrap optional
        let shellAction = ShellAction(commandBuilder: command, workingDirectory: workingDirectory!)
        let output = try await shellAction.run().output
        self.init(buildSettingsOutput: output)
    }

    private init(buildSettingsOutput: String) {
        let pairs = buildSettingsOutput
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .compactMap { line -> (key: String, value: String)? in
                guard let delimeterRange = line.range(of: " = ") else { return nil }
                let key = String(line[line.startIndex ..< delimeterRange.lowerBound])
                let value = String(line[delimeterRange.upperBound...])
                return (key, value)
            }
        let settings = Dictionary(pairs) { first, _ in
            first
        }
        self.init(settings: settings)
    }

    private init(settings: [String: String]) {
        self.settings = settings
    }

    /// Access a specific build setting using the subscript method.
    ///
    /// - Parameter key: The key for the build setting.
    public subscript(key: String) -> String? {
        settings[key]
    }
}

public extension Action {
    /// Returns a `BuildSettings` instance for the specified Xcode project and scheme.
    ///
    /// - Parameters:
    ///   - path: The path to the Xcode project.
    ///   - scheme: The scheme to use for build settings. If `scheme` is not specified, the default scheme is used.
    func showBuildSettings(
        fromXcodeProjectPath path: String,
        scheme: String? = nil
    ) async throws -> BuildSettings {
        try await BuildSettings(xcodeProjectPath: path, scheme: scheme)
    }
}
