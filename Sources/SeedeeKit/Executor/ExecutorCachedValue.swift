//import Foundation
//
//extension TaskExecutor {
//    final class CachedValues: @unchecked Sendable {
//        struct CacheKey: Hashable, Sendable {
//            let identifier: ObjectIdentifier
//        }
//
//        private let recursiveLock = NSRecursiveLock()
//        private var cached: [CacheKey: AnySendable] = [:]
//
//        func value<Key: ExecutorKey>(for key: Key.Type) -> Key.Value {
//            self.recursiveLock.lock()
//
//            defer {
//                self.recursiveLock.unlock()
//            }
//
//            let cacheKey = CacheKey(identifier: ObjectIdentifier(key))
//
//            if let cacheValue = self.cached[cacheKey]?.base as? Key.Value {
//                return cacheValue
//            } else {
//                let value = Key.defaultValue
//                self.cached[cacheKey] = AnySendable(value)
//                return value
//            }
//        }
//    }
//}
