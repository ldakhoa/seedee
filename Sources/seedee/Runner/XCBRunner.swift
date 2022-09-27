import Foundation

protocol XCBRunner {
    func run(argument: String)
    func action() -> XCBAction
}
