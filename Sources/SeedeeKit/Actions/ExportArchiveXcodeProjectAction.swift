import Foundation
import AppStoreConnect_Swift_SDK

struct ExportArchiveXcodeProjectAction: Action {
    let name: String = "Export Archive"

    // MARK: - Dependencies

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
    let exportOptionsPlistPath: String

    /// Allow `xcodebuild` to communicate with the Apple Developer website.
    ///
    /// For automatically signed targets, xcodebuild will create and update profiles, app IDs, and certificates
    let allowProvisioningUpdates: Bool

    /// The custom object that needed to set up the API Provider including all needed information for performing API requests.
    let appStoreConnectKey: APIConfiguration.Key?

    // MARK: - Misc

    private let executor: any Executor

    private let fileManager: FileManager

    private var isUsingAdditionalExportOptions: Bool

    // MARK: - Initializer

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
        exportOptionsPlistPath: String,
        allowProvisioningUpdates: Bool = false,
        appStoreConnectKey: APIConfiguration.Key? = nil,
        fileManager: FileManager = .default,
        executor: any Executor = ProcessExecutor()
    ) {
        self.project = project
        self.archivePath = archivePath
        self.exportPath = exportPath
        self.exportOptionsPlistPath = exportOptionsPlistPath
        self.allowProvisioningUpdates = allowProvisioningUpdates
        self.appStoreConnectKey = appStoreConnectKey
        self.fileManager = fileManager
        self.executor = executor
        self.isUsingAdditionalExportOptions = false
    }

    /// Init the `ExportArchive` object with addition `exportOptions`.
    /// - Parameters:
    ///   - project: The metadata that contains `workingDirectory`, `projectPath`, `workspacePath` and `scheme`.
    ///   - archivePath: Specifies the path to the archive file created by Xcode.
    ///   - exportPath: Specifies the destination directory where the exported file will be placed
    ///   - exportOptions: An object that configures archive exporting.
    ///   - allowProvisioningUpdates: Allow `xcodebuild` to communicate with the Apple Developer website.
    ///   - appStoreConnectKey: The custom object that needed to set up the API Provider including all needed information for performing API requests.
    init(
        project: Project,
        archivePath: String,
        exportPath: String?,
        exportOptions: ExportArchiveOptions,
        allowProvisioningUpdates: Bool = false,
        appStoreConnectKey: APIConfiguration.Key? = nil,
        fileManager: FileManager = .default,
        executor: any Executor = ProcessExecutor()
    ) throws {
        let exportOptionsPlist = try exportOptions.buildPropertyList()
        let plistPath = "\(fileManager.temporaryDirectory.path)/exportOptions.plist"

        fileManager.createFile(atPath: plistPath, contents: exportOptionsPlist)

        self.init(
            project: project,
            archivePath: archivePath,
            exportPath: exportPath,
            exportOptionsPlistPath: plistPath,
            allowProvisioningUpdates: allowProvisioningUpdates,
            appStoreConnectKey: appStoreConnectKey,
            fileManager: fileManager,
            executor: executor
        )

        self.isUsingAdditionalExportOptions = true
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
            .append("-exportOptionsPlist", value: exportOptionsPlistPath)
            .append("-allowProvisioningUpdates", flag: allowProvisioningUpdates)

        if let appStoreConnectKey = appStoreConnectKey {
            commandBuilder
                .append("-authenticationKeyPath", value: appStoreConnectKey.path)
                .append("-authenticationKeyID", value: appStoreConnectKey.privateKeyID)
                .append("-authenticationKeyIssuerID", value: appStoreConnectKey.issuerID)
        }

        return commandBuilder
    }

    func cleanUp(error: Error?) async throws {
        if isUsingAdditionalExportOptions {
            try fileManager.removeItem(atPath: exportOptionsPlistPath)
        }

        try fileManager.removeItem(atPath: archivePath)
    }
}

public extension Action {
    /// Export an archive file Xcode project action.
    ///
    ///  - Parameters:
    ///   - project: The metadata that contains `workingDirectory`, `projectPath`, `workspacePath` and `scheme`.
    ///   - archivePath: Specifies the path to the archive file created by Xcode.
    ///   - exportPath: Specifies the destination directory where the exported file will be placed
    ///   - exportOptionsPlist: Specifies a path to a plist file that configures archive exporting.
    ///   - allowProvisioningUpdates: Allow `xcodebuild` to communicate with the Apple Developer website.
    ///   - appStoreConnectKey: The custom object that needed to set up the API Provider including all needed information for performing API requests.
    /// - Returns: An object that represents the result of executing a command in a shell.
    @discardableResult
    func exportArchiveXcodeProjectAction(
        _ project: Project,
        archivePath: String,
        exportPath: String? = nil,
        exportOptionsPlistPath: String,
        allowProvisioningUpdates: Bool,
        appstoreConnectKey: APIConfiguration.Key? = nil
    ) async throws -> ExecutorResult {
        try await action(
            ExportArchiveXcodeProjectAction(
                project: project,
                archivePath: archivePath,
                exportPath: exportPath,
                exportOptionsPlistPath: exportOptionsPlistPath,
                allowProvisioningUpdates: allowProvisioningUpdates,
                appStoreConnectKey: appstoreConnectKey
            )
        )
    }

    /// Export an archive file Xcode project action.
    ///
    /// - Parameters:
    ///   - project: The metadata that contains `workingDirectory`, `projectPath`, `workspacePath` and `scheme`.
    ///   - archivePath: Specifies the path to the archive file created by Xcode.
    ///   - exportPath: Specifies the destination directory where the exported file will be placed
    ///   - exportOptions: An object that configures archive exporting.
    ///   - allowProvisioningUpdates: Allow `xcodebuild` to communicate with the Apple Developer website.
    ///   - appStoreConnectKey: The custom object that needed to set up the API Provider including all needed information for performing API requests.
    /// - Returns: An object that represents the result of executing a command in a shell.
    @discardableResult
    func exportArchiveXcodeProjectAction(
        _ project: Project,
        archivePath: String,
        exportPath: String? = nil,
        exportOptions: ExportArchiveOptions,
        allowProvisioningUpdates: Bool,
        appstoreConnectKey: APIConfiguration.Key? = nil
    ) async throws -> ExecutorResult {
        try await action(
            ExportArchiveXcodeProjectAction(
                project: project,
                archivePath: archivePath,
                exportPath: exportPath,
                exportOptions: exportOptions,
                allowProvisioningUpdates: allowProvisioningUpdates,
                appStoreConnectKey: appstoreConnectKey
            )
        )
    }
}
