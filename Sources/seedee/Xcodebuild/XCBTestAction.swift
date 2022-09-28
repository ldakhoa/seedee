import Foundation
import Glob

final class XCBTestAction: XCBAction {
    
    private var arguments: Arguments?
    
    override func run(arguments: Arguments) {
        if arguments.derivedDataPath?.isEmpty ?? true {
            arguments.derivedDataPath = "DerivedData"
        }
        super.run(arguments: arguments)
    }
    
    // MARK: - Private
    
    func xcresultPaths() {
        // TODO: Implement this
        guard let arguments = arguments else { return }
        if arguments.derivedDataPath?.isEmpty ?? true {
            arguments.derivedDataPath = "DerivedData"
        }
        
        let files = Glob(pattern: "\(arguments.derivedDataPath ?? "")/Logs/Test/*.xcresult")
        files.forEach {
            print("> DD: ", $0 as String)
        }
    }
}
