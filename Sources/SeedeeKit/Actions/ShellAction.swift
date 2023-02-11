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
    func run() async throws -> ExecutorResult {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<ExecutorResult, Swift.Error>) in
            executor.execute(commandBuilder.command, workingDirectory: workingDirectory) { result in
                switch result {
                case let .success(executorResult):
                    continuation.resume(returning: executorResult)
                case let .failure(error):
                    logger.error("Unable to run `shellAction` \(error.message)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

public extension Action {
    @discardableResult
    func shell(
        _ builder: CommandBuilder,
        workingDirectory: URL = URL(fileURLWithPath: ".")
    ) async throws -> ExecutorResult {
        try await action(ShellAction(
            commandBuilder: builder,
            workingDirectory: workingDirectory))
    }
}
