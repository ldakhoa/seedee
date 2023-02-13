import Foundation
import AppStoreConnect_Swift_SDK

struct ExportArchiveXcodeProjectAction: Action {
    let name: String = "Export Archive"

    /// The metadata that contains `workingDirectory`, `projectPath`, `workspacePath` and `scheme`.
    let project: Project

    /// Specifies the path to the archive file created by Xcode.
    let archivePath: String

    /// Specifies the destination directory where the exported file will be placed
    let exportPath: String?

    /// Specifies a path to a plist file that configures archive exporting.
    ///
    /// The export options plist file is used to configure various aspects of the export process,
    /// such as the signing identity to use for signing the app,
    /// the provisioning profile to use, and the format of the exported file.
    let exportOptionsPlist: String

    /// Allow `xcodebuild` to communicate with the Apple Developer website.
    ///
    /// For automatically signed targets, xcodebuild will create and update profiles, app IDs, and certificates
    let allowProvisioningUpdates: Bool

    /// The custom object that needed to set up the API Provider including all needed information for performing API requests.
    let appStoreConnectKey: APIConfiguration.Key?

    private let executor: any Executor

    /// Init the `ExportArchive` object.
    /// - Parameters:
    ///   - project: The metadata that contains `workingDirectory`, `projectPath`, `workspacePath` and `scheme`.
    ///   - archivePath: Specifies the path to the archive file created by Xcode.
    ///   - exportPath: Specifies the destination directory where the exported file will be placed
    ///   - exportOptionsPlist: Specifies a path to a plist file that configures archive exporting.
    ///   - allowProvisioningUpdates: Allow `xcodebuild` to communicate with the Apple Developer website.
    ///   - appStoreConnectKey: The custom object that needed to set up the API Provider including all needed information for performing API requests.
    init(
        project: Project,
        archivePath: String,
        exportPath: String?,
        exportOptionsPlist: String,
        allowProvisioningUpdates: Bool = false,
        appStoreConnectKey: APIConfiguration.Key? = nil,
        executor: any Executor = ProcessExecutor()
    ) {
        self.project = project
        self.archivePath = archivePath
        self.exportPath = exportPath
        self.exportOptionsPlist = exportOptionsPlist
        self.allowProvisioningUpdates = allowProvisioningUpdates
        self.appStoreConnectKey = appStoreConnectKey
        self.executor = executor
    }

    // MARK: - Action

    func run() async throws -> ExecutorResult {
        let buildCommand = try await buildCommand().command
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<ExecutorResult, Swift.Error>) in
            executor.execute(buildCommand, workingDirectory: project.workingDirectory) { result in
                switch result {
                case let .success(executorResult):
                    continuation.resume(returning: executorResult)
                case let .failure(error):
                    logger.error("Unable to run `exportArchiveXcodeProjectAction` \(error.message)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func buildCommand() async throws -> CommandBuilder {
        let commandBuilder = CommandBuilder("set -o pipefail && xcodebuild -exportArchive")
            .append("-project", value: project.projectPath)
            .append("-archivePath", value: archivePath)
            .append("-exportOptionsPlist", value: exportOptionsPlist)
            .append("-allowProvisioningUpdates", flag: allowProvisioningUpdates)

        if let appStoreConnectKey = appStoreConnectKey {
            commandBuilder
                .append("-authenticationKeyPath", value: appStoreConnectKey.path)
                .append("-authenticationKeyID", value: appStoreConnectKey.privateKeyID)
                .append("-authenticationKeyIssuerID", value: appStoreConnectKey.issuerID)
        }
        
        return commandBuilder
    }
}
