//import Foundation
//
//extension FileManager: @unchecked Sendable {}
//
//extension TaskExecutor {
//    private enum FileManagerKey: ExecutorKey {
//        static let defaultValue = FileManager.default
//    }
//
//    public var fileManager: FileManager {
//        get {
//            self[FileManagerKey.self]
//        }
//        set {
//            self[FileManagerKey.self] = newValue
//        }
//    }
//}
