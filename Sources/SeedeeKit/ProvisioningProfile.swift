import Foundation

public struct ProvisioningProfile: Decodable {
    public let name: String
    public let teamName: String
    public let uuid: String
    public let provisionedDevices: [String]
    public let teamIdentifier: [String]
    public let developerCertificates: [Data]
    public let version: Int

    public init(data: Data) throws {
        let decoder = PropertyListDecoder()
        self = try decoder.decode(ProvisioningProfile.self, from: data)
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
