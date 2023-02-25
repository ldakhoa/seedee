import Foundation
import XCTest
import AppStoreConnect_Swift_SDK
@testable import SeedeeKit

final class ExportArchiveXcodeProjectActionTests: XCTestCase {
//    private let configuration = APIConfiguration.Key(privateKeyID: UUID().uuidString, issuerID: UUID().uuidString, privateKey: "MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgPaXyFvZfNydDEjxgjUCUxyGjXcQxiulEdGxoVbasV3GgCgYIKoZIzj0DAQehRANCAASflx/DU3TUWAoLmqE6hZL9A7i0DWpXtmIDCDiITRznC6K4/WjdIcuMcixy+m6O0IrffxJOablIX2VM8sHRscdr", path: nil)

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

    override func setUp() {
        super.setUp()

        try! XCTSkipUnless(skipUnitTest)
        testDirectory = "\(tempDirectory!)/ExportArchiveXcodeProjectActionTests/"
        archivePath = "\(tempDirectory!)/ExportArchiveXcodeProjectActionTests.xcarchive"

        project = Project(
            workingDirectory: integrationAppPath,
            projectPath: "IntegrationApp.xcodeproj",
            scheme: "IntegrationApp")
    }

    override func setUp() async throws {
        try await super.setUp()

        if setupProvisioningProfile, let provisioningProfilePath {
            // add provisioning profile
            let action = AddProvisioningProfileAction(provisioningProfilePath: provisioningProfilePath)
            try await action.run()
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
        print(buildResult.output)
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
        print(result.output)
        XCTAssertEqual(result.terminationStatus, 0)
        XCTAssertTrue(result.output.lowercased().contains("export succeeded"))
    }
}
