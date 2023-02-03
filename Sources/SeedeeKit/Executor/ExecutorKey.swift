import Foundation

public protocol ExecutorKey {
    associatedtype Value
    static var defaultValue: Value { get }
}
