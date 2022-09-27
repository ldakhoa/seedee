import Foundation

struct XCBTestRunner: XCBRunner {
    func run(argument: String) {
        action().run(argument: argument)
    }
    
    func action() -> XCBAction {
        XCBTestAction()
    }
}
