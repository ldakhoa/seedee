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
        if try await !isInstalled() {
            try await self.install()
        }

        let command = try await buildCommand().command
        return try await executor.execute(command)
    }

    // MARK: - Side Effects - Private

    private func isInstalled() async throws -> Bool {
        try await !executor.execute("which xcversion").output.contains("not found")
    }

    @discardableResult
    private func install() async throws -> ExecutorResult {
        try await executor.execute("gem install xcode-install")
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
