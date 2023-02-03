import Foundation

public struct CommandLineCommand {
    public private(set) var command: String

    init() {
        self.command = ""
    }

    public init(_ staticString: StaticString) {
        self.command = "\(staticString)"
    }

    @discardableResult
    public mutating func append(_ component: String) -> CommandLineCommand {
        command.append(" \(component)")
        return self
    }
}
