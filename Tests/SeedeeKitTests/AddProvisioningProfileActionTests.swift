import Foundation
import XCTest
@testable import SeedeeKit

final class AddProvisioningProfileActionTests: XCTestCase {
    typealias Error = AddProvisioningProfileAction.Error

    private let mockProvisioningProfilePath = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .appendingPathComponent("Resources")
        .appendingPathComponent("mock_provisioning_profile.mobileprovision")

    private var fileManager: FileManager!

    override func setUp() {
        super.setUp()

        fileManager = .default
    }

    func test_addProvisioningProfile_givenValidPath_thenCleanUp() async throws {
        let action = AddProvisioningProfileAction(provisioningProfilePath: mockProvisioningProfilePath)

        XCTAssertEqual(action.provisioningProfilePath, mockProvisioningProfilePath)

        let provisioningProfile = try await action.run()

        XCTAssertEqual(provisioningProfile.name, "iOS Team Provisioning Profile: com.ldakhoa.IntegrationPodApp")
        XCTAssertEqual(provisioningProfile.teamName, "Khoa Le")
        XCTAssertEqual(provisioningProfile.uuid, "1111bdc-111d-1111-af11-1111e1c11db1")

        XCTAssertTrue(provisioningProfile.provisionedDevices.contains("00000000-000C000000FA000E"))
        XCTAssertTrue(provisioningProfile.teamIdentifier.contains("0SB0H0Y0NS"))
        XCTAssertEqual(provisioningProfile.version, 1)

        let profilesDir = fileManager
            .homeDirectoryForCurrentUser
            .appendingPathComponent("Library/MobileDevice/Provisioning Profiles")
            .appendingPathComponent("\(provisioningProfile.uuid).mobileprovision")

        XCTAssertTrue(fileManager.fileExists(atPath: profilesDir.path))

        try await action.cleanUp(error: nil)

        XCTAssertFalse(fileManager.fileExists(atPath: profilesDir.path))
    }

    func test_run_givenWrongPath_shouldThrowError() async throws {
        let wrongPath = fixturePath(for: "mock_provisioning_profile.mobileprovision")
        let action = AddProvisioningProfileAction(provisioningProfilePath: wrongPath)
        do {
            try await action.run()
            XCTFail("Test should be failed")
        } catch let error as Error {
            XCTAssertEqual(Error.failedToReadContents(wrongPath.path), error)
        }

    }
}

extension AddProvisioningProfileAction.Error: Equatable {
    public static func == (
        lhs: AddProvisioningProfileAction.Error,
        rhs: AddProvisioningProfileAction.Error
    ) -> Bool {
        lhs.errorDescription == rhs.errorDescription
    }
}
