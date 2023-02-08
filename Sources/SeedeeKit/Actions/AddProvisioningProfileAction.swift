//import Foundation
//import protocol TSCBasic.FileSystem
//import var TSCBasic.localFileSystem
//
//public struct AddProvisioningProfileAction: Action {
//    private let fileSystem: any FileSystem
//
//    public enum Error: Swift.Error, LocalizedError {
//        case failedToReadContents(String)
//        case failedToCreateProfile(String)
//
//        public var errorDescription: String? {
//             switch self {
//             case let .failedToReadContents(path):
//                 return "Failed to read contents of provisioning profile from \(path)"
//             case let .failedToCreateProfile(path):
//                 return "Failed to create provisioning profile at \(path)"
//             }
//         }
//    }
//
//    public let provisioningProfilePath: URL
//
//    public init(provisioningProfilePath: URL, fileSystem: (any FileSystem) = localFileSystem) {
//        self.provisioningProfilePath = provisioningProfilePath
//        self.fileSystem = fileSystem
//    }
//
//    public func run() async throws -> ProvisioningProfile {
//        logger.info("Adding provisioning profile from \(provisioningProfilePath)")
//
//        guard let contents = try? fileSystem.readFileContents(provisioningProfilePath.absolutePath) else {
//            throw Error.failedToReadContents(provisioningProfilePath.path)
//        }
//
//        let provisioningProfile = try ProvisioningProfile(data: Data(contents.contents))
//
//        let profilesDir = try fileSystem
//            .homeDirectory
//            .appending(component: "Library/MobileDevice/Provisioning Profiles")
//
//        try fileSystem.createDirectory(profilesDir, recursive: true)
//
//        let createdProfilePath = profilesDir
//            .appending(component: "\(provisioningProfile.uuid).mobileprovision")
//
//        try fileSystem.writeFileContents(createdProfilePath, bytes: contents)
//
//        logger.info("Added provisioning profile at \(createdProfilePath)")
//
//        return provisioningProfile
//    }
//}
//
//public extension Action {
//    func addProvisioningProfile(provisioningProfilePath: URL) async throws -> ProvisioningProfile {
//        try await action(AddProvisioningProfileAction(provisioningProfilePath: provisioningProfilePath))
//    }
//}
