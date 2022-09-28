import Foundation

struct XCBTestRunner: XCBRunner {
    func run(arguments: Arguments) {
        action().run(arguments: arguments)
    }
    
    func action() -> XCBActivity {
        XCBTestAction()
    }
}
