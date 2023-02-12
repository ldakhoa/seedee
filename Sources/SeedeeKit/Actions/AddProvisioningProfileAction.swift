import Foundation

struct AddProvisioningProfileAction: Action {

    enum Error: Swift.Error, LocalizedError {
        case failedToReadContents(String)
        case failedToCreateProfile(String)

        var errorDescription: String? {
            switch self {
            case let .failedToReadContents(path):
                return "Failed to read contents of provisioning profile from \(path)"
            case let .failedToCreateProfile(path):
                return "Failed to create provisioning profile at \(path)"
            }
        }
    }

    // MARK: - Dependencies

    let provisioningProfilePath: URL

    // MARK: - Misc

    private let fileManager: FileManager
    @Store private var createdProfilePath: String?

    // MARK: - Initilizer

    init(provisioningProfilePath: URL, fileManager: FileManager = .default) {
        self.provisioningProfilePath = provisioningProfilePath
        self.fileManager = fileManager
    }

    // MARK: - Action

    @discardableResult
    func run() async throws -> ProvisioningProfile {
        logger.info("Adding provisioning profile from \(provisioningProfilePath)")

        guard let contents = fileManager.contents(atPath: provisioningProfilePath.path) else {
            throw Error.failedToReadContents(provisioningProfilePath.path)
        }

        let provisioningProfile = try ProvisioningProfile(data: Data(contents))

        let profilesDir = fileManager
            .homeDirectoryForCurrentUser
            .appendingPathComponent("Library/MobileDevice/Provisioning Profiles")

        try fileManager.createDirectory(at: profilesDir, withIntermediateDirectories: true)

        let createdProfilePath = profilesDir
            .appendingPathComponent("\(provisioningProfile.uuid).mobileprovision")
            .path

        self.createdProfilePath = createdProfilePath

        guard fileManager.createFile(atPath: createdProfilePath, contents: contents) else {
            throw Error.failedToCreateProfile(createdProfilePath)
        }

        logger.info("Added provisioning profile at \(createdProfilePath)")

        return provisioningProfile
    }

    func cleanUp(error: Error?) async throws {
        if let createdProfilePath, !createdProfilePath.isEmpty {
            try fileManager.removeItem(atPath: createdProfilePath)
        }
    }
}

public extension Action {
    func addProvisioningProfile(provisioningProfilePath: URL) async throws -> ProvisioningProfile {
        try await action(AddProvisioningProfileAction(provisioningProfilePath: provisioningProfilePath))
    }
}
