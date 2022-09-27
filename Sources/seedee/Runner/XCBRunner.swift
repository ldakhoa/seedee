import Foundation

protocol XCBRunner {
    func run(argument: Args)
    func action() -> XCBActionProtocol
}
