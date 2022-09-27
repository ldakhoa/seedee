import Foundation

struct XCBBuildRunner: XCBRunner {
    func run(argument: String) {
        action().run(argument: argument)
    }
    
    func action() -> XCBAction {
        XCBBuildAction()
    }
}
