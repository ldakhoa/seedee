@propertyWrapper
public struct Store<T> {
    private class Storage {
        var storeValue: T

        init(storeValue: T) {
            self.storeValue = storeValue
        }
    }

    private let storage: Storage

    public init(wrappedValue: T) {
        self.storage = Storage(storeValue: wrappedValue)
    }

    public var wrappedValue: T {
        get { storage.storeValue }
        nonmutating set { storage.storeValue = newValue }
    }
}
