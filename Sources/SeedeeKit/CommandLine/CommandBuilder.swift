import Foundation

public struct CommandBuilder: Equatable {
    private(set) var command: String

    private init() {
        self.command = ""
    }

    public init(_ staticString: StaticString) {
        self.command = "\(staticString)"
    }

    @discardableResult
    public func append(_ component: String) -> CommandBuilder {
        var newBuilder = self
        newBuilder.command.append(" \(component)")
        return newBuilder
    }

    @discardableResult
    public func append(_ component: StaticString) -> CommandBuilder {
        var newBuilder = self
        newBuilder.command.append(" \(component)")
        return newBuilder
    }

    @discardableResult
    public func append(_ component: StaticString?) -> CommandBuilder {
        var newBuilder = self
        if let component {
            newBuilder.command.append(" \(component)")
        }
        return newBuilder
    }

    @discardableResult
    public func append(
        _ option: StaticString,
        _ separator: StaticString = " ",
        value: String?
    ) -> CommandBuilder {
        var newBuilder = self
        if let value {
            newBuilder.command.append(" \(option)\(separator)\(value)")
        }
        return newBuilder
    }

    @discardableResult
    public func append(
        _ component: StaticString,
        flag: Bool
    ) -> CommandBuilder {
        var newBuilder = self
        if flag {
            newBuilder.command.append(" \(component)")
        }
        return newBuilder
    }

    @discardableResult
    public func build() -> String {
        return self.command
    }
}
