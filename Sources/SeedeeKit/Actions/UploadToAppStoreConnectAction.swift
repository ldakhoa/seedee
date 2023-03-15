import AppStoreConnect_Swift_SDK
import Foundation

/// An action that uploads an IPA file to App Store Connect using the `altool` command-line tool.
public struct UploadToAppStoreConnectAction: Action {

    // MARK: - Internal

    /// The package type to be uploaded, either "ios".
    public enum PackageType: String {
        case iOS = "ios"
    }

    /// An error that occurs when required information is missing.
    enum Error: Swift.Error, LocalizedError {
        case missingBundleVersion
        case missingBundleShortVersion
        case missingBundleID

        var errorDescription: String? {
            switch self {
            case .missingBundleVersion:
                return "Missing bundle version"
            case .missingBundleShortVersion:
                return "Missing bundle short version"
            case .missingBundleID:
                return "Missing bundle ID"
            }
        }
    }

    /// The output of the action.
    public struct Output {}

    // MARK: - Dependencies

    /// The path of the IPA file to be uploaded.
    let ipaPath: String

    /// The metadata that contains `workingDirectory`, `projectPath`, `workspacePath`, and `scheme`.
    let project: Project?

    /// The type of package to upload.
    let type: PackageType

    /// The Apple ID of the app to be uploaded.
    let appAppleID: String?

    /// The CFBundleIdentifier of the app to be uploaded.
    let bundleID: String?

    /// The CFBundleVersion of the app to be uploaded.
    let bundleVersion: String?

    /// The CFBundleShortVersionString of the app to be uploaded.
    let bundleShortVersion: String?

    /// The API key for App Store Connect.
    let appStoreConnectKey: APIConfiguration.Key

    // MARK: - Misc

    /// The executor used to run the `altool` command.
    let executor: any Executor

    // MARK: - Initializer

    /// Initializes a new instance of `UploadToAppStoreConnectAction`.
    /// - Parameters:
    ///   - ipaPath: The path of the IPA file to be uploaded.
    ///   - project: The metadata that contains `workingDirectory`, `projectPath`, `workspacePath`, and `scheme`.
    ///   - type: The type of package to upload.
    ///   - appAppleID: The Apple ID of the app to be uploaded.
    ///   - bundleID: The CFBundleIdentifier of the app to be uploaded.
    ///   - bundleVersion: The CFBundleVersion of the app to be uploaded.
    ///   - bundleShortVersion: The CFBundleShortVersionString of the app to be uploaded.
    ///   - appStoreConnectKey: The API key for App Store Connect.
    ///   - executor: The executor used to run the `altool` command.
    init(
        ipaPath: String,
        project: Project?,
        type: PackageType,
        appAppleID: String?,
        bundleID: String?,
        bundleVersion: String?,
        bundleShortVersion: String?,
        appStoreConnectKey: APIConfiguration.Key,
        executor: any Executor = ProcessExecutor()
    ) {
        self.ipaPath = ipaPath
        self.project = project
        self.type = type
        self.appAppleID = appAppleID
        self.bundleID = bundleID
        self.bundleVersion = bundleVersion
        self.bundleShortVersion = bundleShortVersion
        self.appStoreConnectKey = appStoreConnectKey
        self.executor = executor
    }

    // MARK: - Action

    /// Builds the command to upload the IPA file to App Store Connect using the `altool` command-line tool.
    /// - Returns: A `CommandBuilder` instance.
    public func buildCommand() async throws -> CommandBuilder {
        guard let bundleVersion else {
            throw Error.missingBundleVersion
        }

        guard let bundleID else {
            throw Error.missingBundleID
        }

        guard let bundleShortVersion else {
            throw Error.missingBundleShortVersion
        }

        logger.info("Uploading \(ipaPath) to App Store Connect")

        return CommandBuilder("xcrun altool")
            .append("--upload-package", value: ipaPath)
            .append("--type", value: type.rawValue)
            .append("--apiKey", value: appStoreConnectKey.privateKeyID)
            .append("--apiIssuer", value: appStoreConnectKey.issuerID)
            .append("--bundle-version", value: bundleVersion)
            .append("--bundle-id", value: bundleID)
            .append("--bundle-short-version-string", value: bundleShortVersion)
    }

    /// Runs the action.
    /// - Returns: An instance of `Output`.
    public func run() async throws -> Output {
        return Output()
    }
}

public extension Action {
    /// Uploads an IPA file to App Store Connect using the `altool` command-line tool.
    /// - Parameters:
    ///   - ipaPath: The path of the IPA file to be uploaded.
    ///   - project: The metadata that contains `workingDirectory`, `projectPath`, `workspacePath`, and `scheme`.
    ///   - type: The type of package to upload.
    ///   - appAppleID: The Apple ID of the app to be uploaded.
    ///   - bundleID: The CFBundleIdentifier of the app to be uploaded.
    ///   - bundleVersion: The CFBundleVersion of the app to be uploaded.
    ///   - bundleShortVersion: The CFBundleShortVersionString of the app to be uploaded.
    ///   - appStoreConnectKey: The API key for App Store Connect.
    func uploadToAppStoreConnect(
        ipaPath: String,
        project: Project?,
        type: UploadToAppStoreConnectAction.PackageType,
        appAppleID: String?,
        bundleID: String?,
        bundleVersion: String?,
        bundleShortVersion: String?,
        appStoreConnectKey: APIConfiguration.Key
    ) async throws {
        try await action(UploadToAppStoreConnectAction(
            ipaPath: ipaPath,
            project: project,
            type: type,
            appAppleID: appAppleID,
            bundleID: bundleID,
            bundleVersion: bundleVersion,
            bundleShortVersion: bundleShortVersion,
            appStoreConnectKey: appStoreConnectKey))
    }
}
