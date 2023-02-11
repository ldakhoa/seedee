import Foundation

struct ShellAction: Action {
    let name = "Run Shell"

    let commandBuilder: CommandBuilder
    let workingDirectory: URL
    private let executor: any Executor

    init(
        commandBuilder: CommandBuilder,
        workingDirectory: URL = URL(fileURLWithPath: "."),
        executor: any Executor = ProcessExecutor()
    ) {
        self.commandBuilder = commandBuilder
        self.workingDirectory = workingDirectory
        self.executor = executor
    }

    @discardableResult
    func run() async throws -> String {
        try executor.execute(commandBuilder.command, workingDirectory: workingDirectory).output
    }
}

public extension Action {
    @discardableResult
    func shell(
        _ builder: CommandBuilder,
        workingDirectory: URL = URL(fileURLWithPath: ".")
    ) async throws -> String {
        try await action(ShellAction(
            commandBuilder: builder,
            workingDirectory: workingDirectory))
    }
}
