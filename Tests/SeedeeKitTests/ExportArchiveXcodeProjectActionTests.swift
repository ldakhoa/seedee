import Foundation
import XCTest
import AppStoreConnect_Swift_SDK
@testable import SeedeeKit

final class ExportArchiveXcodeProjectActionTests: XCTestCase {
    private let configuration = APIConfiguration.Key(privateKeyID: UUID().uuidString, issuerID: UUID().uuidString, privateKey: "MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgPaXyFvZfNydDEjxgjUCUxyGjXcQxiulEdGxoVbasV3GgCgYIKoZIzj0DAQehRANCAASflx/DU3TUWAoLmqE6hZL9A7i0DWpXtmIDCDiITRznC6K4/WjdIcuMcixy+m6O0IrffxJOablIX2VM8sHRscdr", path: nil)

    func test_exportArchive() {}
}
