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
    private let arguments: Arguments
    
    init(metadata: Metadata, arguments: Arguments) {
        self.metadata = metadata
        self.arguments = arguments
    }
    
    func make() -> [String]? {
        let defaultDestination = "\'platform=iOS Simulator,name=iPhone 11\'"
        let xcbArguments: OrderedDictionary<String, String> = [
            "derivedDataPath": arguments.derivedDataPath ?? "",
            "xctestrun": "",
            "workspace": metadata.xcworkspacePath ?? "",
            "scheme": metadata.scheme ?? "",
            "project": "",
            "target": "",
            "configuration": "",
            "sdk": "",
            "destination": defaultDestination
        ]
        
        guard let actions = arguments.actions?.joined(separator: " ") else { return nil }

        var commands = "set -o pipefail && "
        commands += "xcodebuild "
        commands += actions
        
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
    private let arguments: Arguments
    
    init(metadata: Metadata, arguments: Arguments) {
        self.metadata = metadata
        self.arguments = arguments
    }
    
    func make() -> [String]? {
        []
    }
}

struct LogCmdMaker: CmdMaker {
    private let metadata: Metadata
    private let arguments: Arguments
    
    init(metadata: Metadata, arguments: Arguments) {
        self.metadata = metadata
        self.arguments = arguments
    }
    
    func make() -> [String]? {
        []
    }
}
