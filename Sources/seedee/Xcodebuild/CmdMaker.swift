import Foundation

protocol CmdMaker {
    func make() -> [String]?
}

extension CmdMaker {
    func make() -> [String]? {
        fatalError("Not implemented")
    }
}

struct XCBCmdMaker: CmdMaker {
    private let metadata: Metadata
    private let argument: String
    
    init(metadata: Metadata, argument: String) {
        self.metadata = metadata
        self.argument = argument
    }
    
    func make() -> [String]? {
        let defaultDestination = "platform-iOS Simulator,name=iPhone 11"
        
        let xcbArguments: [String: Any] = [
            "derivedDataPath": "",
            "xctestrun": "",
            "workspace": metadata.xcworkspacePath ?? "",
            "scheme": "",
            "project": "",
            "target": "",
            "configuration": "",
            "sdk": "",
            "destination": defaultDestination
        ]
        
        return []
    }
}

struct TeeCmdMaker: CmdMaker {
    func make() -> [String]? {
        []
    }
}

struct LogCmdMaker: CmdMaker {
    func make() -> [String]? {
        []
    }
}
