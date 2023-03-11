import Foundation

struct UploadToAppStoreConnectAction: Action {
    struct Output {
    }

    func run() async throws -> Output {
        return Output()
    }
}

public extension Action {
    func uploadToAppStoreConnect() {}
}
