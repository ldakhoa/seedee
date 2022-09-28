import Foundation

protocol XCBRunner {
    func run(arguments: Arguments)
    func action() -> XCBActivity
}
