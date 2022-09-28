import Foundation
import Glob

final class XCBTestAction: XCBAction {
    override func run(arguments: Arguments) {
        if arguments.derivedDataPath?.isEmpty ?? true {
            arguments.derivedDataPath = "DerivedData"
        }
        super.run(arguments: arguments)
        
        // TODO: Handle multiple xcresult bundles
        let files = Glob(pattern: "\(arguments.derivedDataPath ?? "")/Logs/Test/*.xcresult")
        let paths = files.compactMap {
            URL(string: $0)?
                .lastPathComponent
        }
        
        if paths.isEmpty {
            Logger.shared.log(type: .error, message: "Cannot detect any xcresult bundle")
        }
       
        Logger.shared.log(type: .info, message: "Detected xcresult bundles: \(paths)")
    }
}
