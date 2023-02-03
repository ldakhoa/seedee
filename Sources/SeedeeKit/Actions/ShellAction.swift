import Foundation

public struct ShellAction: Action {
    public let name = "Run Shell"

    let builder: CommandBuilder

    public init(builder: CommandBuilder) {
        self.builder = builder
    }

    public func run() async throws -> String {
        try executor.shell(builder)
    }
}

public extension Action {
    @discardableResult
    func shell(_ builder: CommandBuilder) async throws -> String {
        try await action(ShellAction(builder: builder))
    }
}
