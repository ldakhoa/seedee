import Foundation
import XCTest
import AppStoreConnect_Swift_SDK
@testable import SeedeeKit

final class ExportArchiveXcodeProjectActionTests: XCTestCase {
    var fileManager: FileManager = .default
    var project: Project!

    var testDirectory: String!
    var archivePath: String!

    private var setupProvisioningProfile: Bool {
        if let value = ProcessInfo.processInfo.environment["SETUP_PROVISIONING_PROFILE"], !value.isEmpty {
            return true
        }
        return false
    }

    private var tempDirectory: String? {
        if let value = ProcessInfo.processInfo.environment["TEMP_DIR"], !value.isEmpty {
            return value
        }
        return fileManager.temporaryDirectory.path
    }

    private var provisioningProfilePath: URL? {
        if let tempDirectory {
            let path = URL(fileURLWithPath: "\(tempDirectory)/seedee_provisioning_profile.mobileprovision")
            return path
        }
        return nil
    }

    private var provisioningProfileBase64: String? {
        if let value = ProcessInfo.processInfo.environment["PROVISIONING_PROFILE"], !value.isEmpty {
            return value
        }

        return nil
    }

    override func setUp() {
        #warning("Fix - Make it work on CI pipeline")
        try! XCTSkipUnless(true)

        super.setUp()

        testDirectory = "\(tempDirectory!)/ExportArchiveXcodeProjectActionTests/"
        archivePath = "\(tempDirectory!)/ExportArchiveXcodeProjectActionTests.xcarchive"

        project = Project(
            workingDirectory: integrationAppPath,
            projectPath: "IntegrationApp.xcodeproj",
            scheme: "IntegrationApp")
    }

    override func setUp() async throws {
        try await super.setUp()

        if setupProvisioningProfile {
            guard
                let provisioningProfilePath = provisioningProfilePath,
                let provisioningProfileBase64 = provisioningProfileBase64,
                let decodedData = Data(base64Encoded: provisioningProfileBase64)
            else {
                fatalError("Failed to decoded data at \(String(describing: self.provisioningProfilePath?.path))")
            }
            fileManager.createFile(atPath: provisioningProfilePath.path, contents: decodedData)

            // add provisioning profile
            let action = AddProvisioningProfileAction(provisioningProfilePath: provisioningProfilePath)

            // remove print debug after pass CI test
            let provisioningProfile = try await action.run()
            print("Provisioning info: ", provisioningProfile.uuid, provisioningProfile.name)
        }
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        try fileManager.removeItem(atPath: testDirectory)
        try fileManager.removeItem(atPath: archivePath)

        if setupProvisioningProfile, let provisioningProfilePath {
            try fileManager.removeItem(at: provisioningProfilePath)
        }
    }

    func test_exportArchive_whenGivenExportOptionsPlistPath() async throws {
        // Archive project
        let buildAction = BuildXcodeProjectAction(
            project: project,
            buildConfiguration: .release,
            cleanBuild: true,
            archivePath: archivePath,
            projectVersion: "1.0.0"
        )

        let buildResult = try await buildAction.run()
        XCTAssertEqual(buildResult.terminationStatus, 0)
        XCTAssertTrue(buildResult.output.lowercased().contains("archive succeeded"))

        try fileManager.createDirectory(atPath: testDirectory, withIntermediateDirectories: true)

        let action = ExportArchiveXcodeProjectAction(
            project: project,
            archivePath: archivePath,
            exportPath: testDirectory,
            exportOptionsPlistPath: "\(tempDirectory!)/ExportOptions.plist"
        )

        let result = try await action.run()
        XCTAssertEqual(result.terminationStatus, 0)
        XCTAssertTrue(result.output.lowercased().contains("export succeeded"))
    }
}
