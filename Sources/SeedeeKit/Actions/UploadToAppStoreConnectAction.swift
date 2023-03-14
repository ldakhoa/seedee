import Foundation
import AppStoreConnect_Swift_SDK

struct UploadToAppStoreConnectAction: Action {
    /// Path to .ipa.
    let ipaPath: String

    /// The metadata that contains `workingDirectory`, `projectPath`, `workspacePath` and `scheme`.
    let project: Project?

    let type: PackageType

    let appStoreConnectKey: APIConfiguration.Key

    let executor: any Executor

    init(
        ipaPath: String,
        project: Project?,
        type: PackageType = .iOS,
        appStoreConnectKey: APIConfiguration.Key,
        executor: any Executor = ProcessExecutor()
    ) {
        self.ipaPath = ipaPath
        self.project = project
        self.type = type
        self.appStoreConnectKey = appStoreConnectKey
        self.executor = executor
    }

    enum PackageType: String {
        case iOS = "ios"
    }

    struct Output {

    }

    // MARK: - Action

    func buildCommand() async throws -> CommandBuilder {
        CommandBuilder("xcrun altool")
            .append("--upload-package", value: ipaPath)
            .append("--type", value: type.rawValue)
            .append("--apiKey", value: appStoreConnectKey.privateKeyID)
            .append("--apiIssuer", value: appStoreConnectKey.issuerID)
    }

    func run() async throws -> Output {
        return Output()
    }
}

public extension Action {
    func uploadToAppStoreConnect() {}
}
