import Foundation

public protocol Executor {
    var executor: TaskExecutor { get }
}

public extension Executor {
    var executor: TaskExecutor { .current }
}

public struct TaskExecutor: Sendable {
    @TaskLocal public static var current = Self()

    private var implicitValues = CachedValues()
    private var explicitValues: [ObjectIdentifier: AnySendable] = [:]

    public subscript<Key: ExecutorKey>(key: Key.Type) -> Key.Value where Key.Value: Sendable {
        get {
            if let explicitValue = self.explicitValues[ObjectIdentifier(key)]?.base as? Key.Value {
                return explicitValue
            } else {
                return self.implicitValues.value(for: Key.self)
            }
        }
        set {
            self.explicitValues[ObjectIdentifier(key)] = AnySendable(newValue)
        }
    }
}

@propertyWrapper
public struct ExecutorWrapper<Value> {
    let keyPath: KeyPath<TaskExecutor, Value>

    public var wrappedValue: Value {
        TaskExecutor.current[keyPath: keyPath]
    }

    public init(_ keyPath: KeyPath<TaskExecutor, Value>) {
        self.keyPath = keyPath
    }
}
