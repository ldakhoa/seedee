import Foundation

struct XCBTestRunner: XCBRunner {
    func run(argument: Args) {
        action().run(argument: argument)
    }
    
    func action() -> XCBActionProtocol {
        XCBTestAction()
    }
}
