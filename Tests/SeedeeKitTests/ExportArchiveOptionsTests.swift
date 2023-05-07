import Foundation
import XCTest
@testable import SeedeeKit

final class ExportArchiveOptionsTests: XCTestCase {
    var manifest: ExportArchiveOptions.Manifest!

    override func setUp() {
        super.setUp()

        manifest = ExportArchiveOptions.Manifest(
            appURL: "https://seedee.com/appurl",
            displayImageURL: "https://seedee.com/displayimageurl",
            fullSizeImageURL: "https://seedee.com/fullsizeimageurl")
    }

    func test_buildPropertyList_whenDistributionIsNonAppStore_andSiginingAutomatic() async throws {
        let options = ExportArchiveOptions(
            method: .adHoc,
            distribution: .nonAppStore(
                manifest: manifest,
                compileBitcode: false,
                onDemandResources: nil,
                thinning: .none
            ),
            signing: .automatic,
            distributionBundleIdentifier: "com.example.app",
            iCloudContainerEnvironment: "Production",
            stripSwiftSymbols: false,
            teamID: "ABCDE12345"
        )

        let expected: [String: Any] = [
            "signingStyle": "automatic",
            "embedOnDemandResourcesAssetPacksInBundle": true,
            "stripSwiftSymbols": false,
            "manageAppVersionAndBuildNumber": false,
            "manifest": [
                "appURL": "https://seedee.com/appurl",
                "displayImageURL": "https://seedee.com/displayimageurl",
                "fullSizeImageURL": "https://seedee.com/fullsizeimageurl"
            ],
            "uploadSymbols": false,
            "method": "ad-hoc",
            "teamID": "ABCDE12345",
            "thinning": "<none>",
            "destination": "export",
            "compileBitcode": false,
            "distributionBundleIdentifier": "com.example.app",
            "generateAppStoreInformation": false,
            "iCloudContainerEnvironment": "Production"
        ]

        let plistData = try options.buildPropertyList()

        let plist = try PropertyListSerialization.propertyList(
            from: plistData,
            options: [],
            format: nil
        ) as? [String: Any]

        XCTAssertNotNil(plist)
        XCTAssertEqual(plist! as NSDictionary, expected as NSDictionary)
    }

    func test_buildPropertyList_whenDistributionIsNonAppStore_andSiginingManual() async throws {
        let additionalOptions = ExportArchiveOptions.BuiltInSigning.AdditionalSigningOptions(signingCertificate: .sha1(hash: "mock.hash.ExportArchiveOptions.BuiltInSigning.AdditionalSigningOptions"))
        let options = ExportArchiveOptions(
            method: .adHoc,
            distribution: .nonAppStore(
                manifest: manifest,
                compileBitcode: false,
                onDemandResources: nil,
                thinning: .none
            ),
            signing: .manual(
                provisioningProfile: ["provisioningProfileKey": "provisioningProfileValue"],
                additionalSigningOptions: additionalOptions),
            distributionBundleIdentifier: "com.example.app",
            iCloudContainerEnvironment: "Production",
            stripSwiftSymbols: false,
            teamID: "ABCDE12345"
        )

        let expected: [String: Any] = [
            "signingStyle": "manual",
            "embedOnDemandResourcesAssetPacksInBundle": true,
            "stripSwiftSymbols": false,
            "manageAppVersionAndBuildNumber": false,
            "manifest": [
                "appURL": "https://seedee.com/appurl",
                "displayImageURL": "https://seedee.com/displayimageurl",
                "fullSizeImageURL": "https://seedee.com/fullsizeimageurl"
            ],
            "provisioningProfiles": ["provisioningProfileKey": "provisioningProfileValue"],
            "signingCertificate": "mock.hash.ExportArchiveOptions.BuiltInSigning.AdditionalSigningOptions",
            "uploadSymbols": false,
            "method": "ad-hoc",
            "teamID": "ABCDE12345",
            "thinning": "<none>",
            "destination": "export",
            "compileBitcode": false,
            "distributionBundleIdentifier": "com.example.app",
            "generateAppStoreInformation": false,
            "iCloudContainerEnvironment": "Production"
        ]

        let plistData = try options.buildPropertyList()

        let plist = try PropertyListSerialization.propertyList(
            from: plistData,
            options: [],
            format: nil
        ) as? [String: Any]

        XCTAssertNotNil(plist)
        XCTAssertEqual(plist! as NSDictionary, expected as NSDictionary)
    }

    func test_buildPropertyList_whenDistributionIsAppStore_andSiginingAutomatic() async throws {
        let options = ExportArchiveOptions(
            method: .development,
            distribution: .appStore(uploadToAppStore: true),
            signing: .automatic,
            distributionBundleIdentifier: "com.example.app",
            iCloudContainerEnvironment: "Production",
            stripSwiftSymbols: false,
            teamID: "ABCDE12345"
        )

        let plistData = try options.buildPropertyList()

        let plist = try PropertyListSerialization.propertyList(
            from: plistData,
            options: [],
            format: nil
        ) as? [String: Any]

        let expected: [String: Any] = [
            "signingStyle": "automatic",
            "teamID": "ABCDE12345",
            "thinning": "<none>",
            "embedOnDemandResourcesAssetPacksInBundle": true,
            "iCloudContainerEnvironment": "Production",
            "generateAppStoreInformation": false,
            "manageAppVersionAndBuildNumber": true,
            "uploadSymbols": true,
            "method": "development",
            "destination": "upload",
            "compileBitcode": true,
            "distributionBundleIdentifier": "com.example.app",
            "stripSwiftSymbols": false
        ]

        XCTAssertNotNil(plist)
        XCTAssertEqual(plist! as NSDictionary, expected as NSDictionary)
    }

    func test_buildPropertyList_whenDistributionIsAppStore_andSiginingManual() async throws {
        let additionalOptions = ExportArchiveOptions.BuiltInSigning.AdditionalSigningOptions(signingCertificate: .sha1(hash: "mock.hash.ExportArchiveOptions.BuiltInSigning.AdditionalSigningOptions"))
        let options = ExportArchiveOptions(
            method: .adHoc,
            distribution: .appStore(uploadToAppStore: true),
            signing: .manual(
                provisioningProfile: ["provisioningProfileKey": "provisioningProfileValue"],
                additionalSigningOptions: additionalOptions),
            distributionBundleIdentifier: "com.example.app",
            iCloudContainerEnvironment: "Production",
            stripSwiftSymbols: false,
            teamID: "ABCDE12345"
        )

        let expected: [String: Any] = [
            "signingStyle": "manual",
            "compileBitcode": true,
            "signingCertificate": "mock.hash.ExportArchiveOptions.BuiltInSigning.AdditionalSigningOptions",
            "generateAppStoreInformation": false,
            "provisioningProfiles": ["provisioningProfileKey": "provisioningProfileValue"],
            "teamID": "ABCDE12345",
            "iCloudContainerEnvironment": "Production",
            "method": "ad-hoc",
            "manageAppVersionAndBuildNumber": true,
            "uploadSymbols": true,
            "distributionBundleIdentifier": "com.example.app",
            "thinning": "<none>",
            "embedOnDemandResourcesAssetPacksInBundle": true,
            "destination": "upload",
            "stripSwiftSymbols": false
        ]

        let plistData = try options.buildPropertyList()

        let plist = try PropertyListSerialization.propertyList(
            from: plistData,
            options: [],
            format: nil
        ) as? [String: Any]

        XCTAssertNotNil(plist)
        XCTAssertEqual(plist! as NSDictionary, expected as NSDictionary)
    }
}
