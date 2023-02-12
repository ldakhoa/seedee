import Foundation

public struct ProvisioningProfile: Decodable {
    public enum Error: Swift.Error, LocalizedError {
        case failedToDecodeProvisioningProfile

        public var errorDescription: String? {
            switch self {
            case .failedToDecodeProvisioningProfile:
                return "Failed to decode Provisioning Profile"
            }
        }
    }

    public let name: String
    public let teamName: String
    public let uuid: String
    public let provisionedDevices: [String]
    public let teamIdentifier: [String]
    public let developerCertificates: [Data]
    public let version: Int

    public init(data: Data) throws {
        let string = String(decoding: data, as: UTF8.self)

        guard
            let openRange = string.range(of: "<?xml"),
            let closeRange = string.range(of: "</plist>")
        else {
            throw Error.failedToDecodeProvisioningProfile
        }

        let plist = string[openRange.lowerBound...closeRange.upperBound]
        self = try PropertyListDecoder().decode(ProvisioningProfile.self, from: Data(plist.utf8))
    }

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case teamName = "TeamName"
        case uuid = "UUID"
        case provisionedDevices = "ProvisionedDevices"
        case teamIdentifier = "TeamIdentifier"
        case developerCertificates = "DeveloperCertificates"
        case version = "Version"
    }
}
