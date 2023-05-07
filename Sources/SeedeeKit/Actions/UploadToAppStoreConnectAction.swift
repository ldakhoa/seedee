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
        case appNotFound(bundleID: String)
        case missingAppAppleID

        var errorDescription: String? {
            switch self {
            case .missingBundleVersion:
                return "Missing bundle version"
            case .missingBundleShortVersion:
                return "Missing bundle short version"
            case .missingBundleID:
                return "Missing bundle ID"
            case let .appNotFound(bundleID):
                return """
Failed to find an app with the provided bundle id \(bundleID) on App Store Connect.
Please verify that the bundle id is correct and ensure that the app has been created on App Store Connect.
If the problem persists, please check your account permissions or contact Apple Developer Support for assistance.
"""
            case .missingAppAppleID:
                return "Missing App Apple ID"
            }
        }
    }

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

    private let provider: APIProvider

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
        self.provider = APIProvider(configuration: APIConfiguration(
            issuerID: appStoreConnectKey.issuerID,
            privateKeyID: appStoreConnectKey.privateKeyID,
            privateKey: appStoreConnectKey.privateKey)
        )
    }

    // MARK: - Action

    /// Builds the command to upload the IPA file to App Store Connect using the `altool` command-line tool.
    /// - Returns: A `CommandBuilder` instance.
    public func buildCommand() async throws -> CommandBuilder {
        var appAppleID = self.appAppleID
        var bundleVersion = self.bundleVersion
        var bundleShortVersion = self.bundleShortVersion
        var bundleID = self.bundleID

    versions: if bundleShortVersion == nil || bundleShortVersion == nil || bundleID == nil {
        guard let buildSettings = try? await showBuildSettings(
            fromXcodeProjectPath: project?.projectPath ?? "",
            scheme: project?.scheme
        ) else {
            logger.debug("Couldn't get build settings from Xcode project.")
            break versions
        }

        if bundleShortVersion == nil {
            if let projectBundleShortVersion = buildSettings["MARKETING_VERSION"] {
                bundleShortVersion = projectBundleShortVersion
                logger.debug("Detected bundle short version from xcode project: \(projectBundleShortVersion)")
            } else {
                logger.debug("Couldn't detect bundle short version from Xcode project build settings.")
            }
        }

        if bundleVersion == nil {
            if let projectBundleVersion = buildSettings["CURRENT_PROJECT_VERSION"] {
                bundleVersion = projectBundleVersion
                logger.debug("Detected bundle version from xcode project: \(projectBundleVersion)")
            } else {
                logger.debug("Couldn't detect bundle version from Xcode project build settings.")
            }
        }

        if bundleID == nil {
            if let projectBundleID = buildSettings["PRODUCT_BUNDLE_IDENTIFIER"] {
                bundleID = projectBundleID
                logger.debug("Detected bundle id from xcode project: \(projectBundleID)")
            } else {
                logger.debug("Couldn't detect bundle id from Xcode project build settings.")
            }
        }
    }

        guard let bundleVersion else {
            throw Error.missingBundleVersion
        }

        guard let bundleID else {
            throw Error.missingBundleID
        }

        guard let bundleShortVersion else {
            throw Error.missingBundleShortVersion
        }

        do {
            let request = APIEndpoint
                .v1
                .apps
                .get()
            let apps = try await self.provider.request(request).data
            guard let app = apps.first(where: { $0.attributes?.bundleID == bundleID }) else {
                throw Error.appNotFound(bundleID: bundleID)
            }

            if appAppleID == nil {
                appAppleID = app.id
                logger.info("Detected app Apple ID from App Store Connect: \(app.id)")
            }
        } catch {
            logger.error("Failed to get apps from App Store Connect")
        }

        guard let appAppleID else {
            throw Error.missingAppAppleID
        }

        logger.info("Uploading \(ipaPath) to App Store Connect")

        return CommandBuilder("xcrun altool")
            .append("--upload-package", value: ipaPath)
            .append("--type", value: type.rawValue)
            .append("--apple-id", value: appAppleID)
            .append("--apiKey", value: appStoreConnectKey.privateKeyID)
            .append("--apiIssuer", value: appStoreConnectKey.issuerID)
            .append("--bundle-version", value: bundleVersion)
            .append("--bundle-id", value: bundleID)
            .append("--bundle-short-version-string", value: bundleShortVersion)
    }

    public func run() async throws -> ExecutorResult {
        try await executor.execute(buildCommand().command)
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
