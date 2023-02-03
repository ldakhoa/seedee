import Foundation

public struct TaskExecutor: Sendable {
    @TaskLocal public static var current = Self()

}

@propertyWrapper
public struct ExecutorWrapper<Value> {
    let keyPath: KeyPath<TaskExecutor, Value>

    public var wrappedValue: Value {
        TaskExecutor.current[keyPath: keyPath]
    }
}

public protocol Executor {
    var executor: TaskExecutor { get }
}

public extension Executor {
    var executor: TaskExecutor { .current }
}
