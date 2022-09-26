import Foundation

protocol XCBRunner {
    func run(argument: String)
    func action() -> XCBAction
}

struct XCBBuildRunner: XCBRunner {
    func run(argument: String) {
        action().run(argument: argument)
    }
    
    func action() -> XCBAction {
        XCBBuildAction()
    }
}

struct XCBTestRunner: XCBRunner {
    func run(argument: String) {
        action().run(argument: argument)
    }
    
    func action() -> XCBAction {
        XCBTestAction()
    }
}
