import Foundation
import XCTest
@testable import SeedeeKit

final class ExportArchiveOptionsTests: XCTestCase {

    func test_buildPropertyList() throws {
        // given
        let options = ExportArchiveOptions(
            compileBitcode: true,
            destination: .upload,
            method: .development,
            signingStyle: .manual,
            stripSwiftSymbols: true,
            teamID: "12345678",
            uploadSymbols: true,
            manageAppVersionAndBuildNumber: true,
            distributionBundleIdentifier: "com.example.myapp",
            provisinioningProfile: ["UUID": "MyProvisioningProfile"])

        // when
        let plistData = try options.buildPropertyList()

        // then
        let plist = try PropertyListSerialization.propertyList(
            from: plistData,
            options: [],
            format: nil
        ) as? [String: Any]

        XCTAssertNotNil(plist)
        XCTAssertEqual(plist?["compileBitcode"] as? Bool, true)
        XCTAssertEqual(plist?["destination"] as? String, "upload")
        XCTAssertEqual(plist?["method"] as? String, "development")
        XCTAssertEqual(plist?["signingStyle"] as? String, "manual")
        XCTAssertEqual(plist?["stripSwiftSymbols"] as? Bool, true)
        XCTAssertEqual(plist?["teamID"] as? String, "12345678")
        XCTAssertEqual(plist?["uploadSymbols"] as? Bool, true)
        XCTAssertEqual(plist?["manageAppVersionAndBuildNumber"] as? Bool, true)
        XCTAssertEqual(plist?["distributionBundleIdentifier"] as? String, "com.example.myapp")
        XCTAssertEqual(plist?["provisinioningProfile"] as? [String: String], ["UUID": "MyProvisioningProfile"])
    }
}
