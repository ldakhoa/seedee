import Foundation

struct XCBBuildRunner: XCBRunner {
    func run(argument: Args) {
        action().run(argument: argument)
    }
    
    func action() -> XCBActionProtocol {
        XCBBuildAction()
    }
}
