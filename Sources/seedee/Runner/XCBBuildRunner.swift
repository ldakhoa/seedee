import Foundation

struct XCBBuildRunner: XCBRunner {
    func run(arguments: Arguments) {
        action().run(arguments: arguments)
    }
    
    func action() -> XCBActivity {
        XCBBuildAction()
    }
}
