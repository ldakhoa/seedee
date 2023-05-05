import Foundation

struct SelectXcodeVersionAction: Action {

    // MARK: - Dependencies

    /// The version of Xcode to select.
    private let version: String

    // MARK: - Misc

    private let executor: any Executor

    // MARK: - Initialize

    /// Initializes a new `SelectXcodeVersionAction` instance.
    /// - Parameters:
    ///   - version: The version of Xcode to select.
    init(
        version: String,
        executor: any Executor = ProcessExecutor()
    ) {
        self.version = version
        self.executor = executor
    }

    // MARK: - Action

    func buildCommand() async throws -> CommandBuilder {
        CommandBuilder("xcversion")
            .append("\(version)")
    }

    func run() async throws -> ExecutorResult {
        try self.checkIsInstalled { installed in
            if !installed {
                self.install()
            }
        }

        let command = try await buildCommand().command
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<ExecutorResult, Swift.Error>) in
            executor.execute(command) { result in
                switch result {
                case let .success(executorResult):
                    continuation.resume(returning: executorResult)
                case let .failure(error):
                    logger.error("Unable to select xcode version \(error.message)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    // MARK: - Side Effects - Private

    private func checkIsInstalled(completion: @escaping (Bool) -> Void) throws {
        do {
            executor.execute("which xcversion") { result in
                switch result {
                case let .success(success):
                    completion(!success.output.contains("not found"))
                case .failure:
                    completion(false)
                }
            }
        }
    }

    private func install() {
        do {
            executor.execute("gem install xcode-install") { result in
                switch result {
                case .success:
                    logger.info("Succeeded install xcode-install")
                case let .failure(failure):
                    logger.error(failure.output)
                }
            }
        }
    }
}

public extension Action {
    /// Selects the specified version of Xcode.
    ///
    /// - Parameter version: The version of Xcode to select.
    func selectXcodeVersion(version: String) async throws {
        try await action(SelectXcodeVersionAction(version: version))
    }
}
