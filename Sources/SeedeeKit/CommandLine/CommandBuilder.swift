import Foundation

public struct CommandBuilder: Equatable {
    private(set) var command: [String]

    private init() {
        self.command = []
    }

    public init(_ str: String) {
        self.command = [str]
    }

    public init(_ str: [String]) {
        self.command = str
    }

    @discardableResult
    public func append(_ component: String) -> CommandBuilder {
        var newBuilder = self
        newBuilder.command.append(component)
        return newBuilder
    }

    @discardableResult
    public func append(_ component: String?) -> CommandBuilder {
        var newBuilder = self
        if let component = component {
            newBuilder.command.append(component)
        }
        return newBuilder
    }

    @discardableResult
    public func append(
        _ option: String,
        _ separator: String = " ",
        value: String?
    ) -> CommandBuilder {
        var newBuilder = self
        if let value = value {
            newBuilder.command.append(option)
            if separator != " " {
                newBuilder.command.append(separator)
            }
            newBuilder.command.append(value)
        }
        return newBuilder
    }

    @discardableResult
    public func append(
        _ component: String,
        flag: Bool
    ) -> CommandBuilder {
        var newBuilder = self
        if flag {
            newBuilder.command.append(component)
        }
        return newBuilder
    }
}
