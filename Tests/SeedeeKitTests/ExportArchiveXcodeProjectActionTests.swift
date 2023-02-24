import Foundation
import XCTest
import AppStoreConnect_Swift_SDK
@testable import SeedeeKit

final class ExportArchiveXcodeProjectActionTests: XCTestCase {
//    private let configuration = APIConfiguration.Key(privateKeyID: UUID().uuidString, issuerID: UUID().uuidString, privateKey: "MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgPaXyFvZfNydDEjxgjUCUxyGjXcQxiulEdGxoVbasV3GgCgYIKoZIzj0DAQehRANCAASflx/DU3TUWAoLmqE6hZL9A7i0DWpXtmIDCDiITRznC6K4/WjdIcuMcixy+m6O0IrffxJOablIX2VM8sHRscdr", path: nil)

    var fileManager: FileManager!
    var project: Project!

    var testDirectory: String!
    var archivePath: String!

    override func setUp() {
        super.setUp()

        fileManager = .default

        let tempDirectory = NSTemporaryDirectory()
        testDirectory = "\(tempDirectory)ExportArchiveXcodeProjectActionTests/"
        archivePath = "\(tempDirectory)ExportArchiveXcodeProjectActionTests.xcarchive"

        project = Project(
            workingDirectory: integrationAppPath,
            projectPath: "IntegrationApp.xcodeproj",
            scheme: "IntegrationApp")
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        try fileManager.removeItem(atPath: testDirectory)
        try fileManager.removeItem(atPath: archivePath)
    }

    func test_exportArchive_whenGivenExportOptionsPlistPath() async throws {

        try! fileManager.createDirectory(atPath: testDirectory, withIntermediateDirectories: true)

        let tempDirectory = NSTemporaryDirectory()

        let action = ExportArchiveXcodeProjectAction(
            project: project,
            archivePath: archivePath,
            exportPath: testDirectory,
            exportOptionsPlistPath: "\(tempDirectory)ExportOptions.plist"
        )

        let result = try await action.run()
        print(result.output)
        XCTAssertEqual(result.terminationStatus, 0)
        XCTAssertTrue(result.output.lowercased().contains("export succeeded"))
    }
}
