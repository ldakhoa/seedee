import Foundation

protocol XCBAction {
    func run(argument: String)
}

extension XCBAction {
    func run(argument: String) {
        let metadata = Metadata()
        let makers: [CmdMaker] = [
            XCBCmdMaker(metadata: metadata, argument: argument)
        ]
        
        makers.forEach {
            print($0.make() ?? "")
        }
    }
}

struct XCBBuildAction: XCBAction {}

struct XCBTestAction: XCBAction {}
