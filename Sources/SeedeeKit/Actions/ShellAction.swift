import Foundation

public struct ShellAction: Action {
    public let name = "Run Shell"

    let commandBuilder: CommandBuilder
    let workingDirectory: String?

    public init(
        commandBuilder: CommandBuilder,
        workingDirectory: String? = nil
    ) {
        self.commandBuilder = commandBuilder
        self.workingDirectory = workingDirectory
    }

    @discardableResult
    public func run() async throws -> String {
        try executor.shell(commandBuilder, workingDirectory: workingDirectory)
    }
}

public extension Action {
    @discardableResult
    func shell(
        _ builder: CommandBuilder,
        workingDirectory: String? = nil
    ) async throws -> String {
        try await action(ShellAction(commandBuilder: builder, workingDirectory: workingDirectory))
    }
}
