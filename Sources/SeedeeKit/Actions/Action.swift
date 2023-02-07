import Foundation

public protocol Action<Output>: Executor {
    associatedtype Output

    var name: String { get }
    func run() async throws -> Output
    func cleanUp(error: Error?) async throws
    func buildCommand() async throws -> CommandBuilder
}

public extension Action {
    var name: String {
        "\(Self.self)"
    }

    func cleanUp(error: Error?) async throws {}
    func buildCommand() async throws -> CommandBuilder { CommandBuilder("") }
}

public extension Action {
    @discardableResult
    func action<A: Action>(_ action: A) async throws -> A.Output {
        let output = try await action.run()
        return output
    }
}
