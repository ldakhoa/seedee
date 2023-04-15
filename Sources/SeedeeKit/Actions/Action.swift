import Foundation
import Logging

public protocol Action<Output> {
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
        LoggingSystem.bootstrap()
        let output = try await action.run()
        return output
    }
}
