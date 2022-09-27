import Foundation
import Collections

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
    private let argument: Args
    
    init(metadata: Metadata, argument: Args) {
        self.metadata = metadata
        self.argument = argument
    }
    
    func make() -> [String]? {
        let defaultDestination = "\'platform=iOS Simulator,name=iPhone 11\'"
        let xcbArguments: OrderedDictionary<String, String> = [
            "derivedDataPath": "",
            "xctestrun": "",
            "workspace": metadata.xcworkspacePath ?? "",
            "scheme": metadata.scheme ?? "",
            "project": "",
            "target": "",
            "configuration": "",
            "sdk": "",
            "destination": defaultDestination
        ]
        
        var commands = "xcodebuild"
        
        for (key, value) in xcbArguments {
            if value.isEmpty { continue }
            commands += " -\(key)" + " \(value)"
        }
        
        // TODO: Handle clean, xcargs
        return [commands]
    }
}

struct TeeCmdMaker: CmdMaker {
    private let metadata: Metadata
    private let argument: Args
    
    init(metadata: Metadata, argument: Args) {
        self.metadata = metadata
        self.argument = argument
    }
    
    func make() -> [String]? {
        []
    }
}

struct LogCmdMaker: CmdMaker {
    private let metadata: Metadata
    private let argument: Args
    
    init(metadata: Metadata, argument: Args) {
        self.metadata = metadata
        self.argument = argument
    }
    
    func make() -> [String]? {
        []
    }
}
