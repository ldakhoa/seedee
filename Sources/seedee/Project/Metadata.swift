import Foundation
import Glob
import ColorizeSwift

struct Metadata {
    private let fileManager = FileManager.default
    
    var xcodeprojPath: String {
        let files = Glob(pattern: "*.xcodeproj")
        
        if files.count > 1 {
            print("warning:".bold().yellow(), "Multiple xcode projects are detected")
        }
        
        let path = files[0] as String
        return dropLast(path)
    }
    
    var xcworkspacePath: String? {
        let files = Glob(pattern: "*.xcworkspace")
        let path = files[0] as String
        return files.isEmpty ? nil : dropLast(path)
    }
    
    var projectName: String? {
        URL(string: xcodeprojPath)?
            .deletingPathExtension()
            .lastPathComponent
    }
    
    var schemes: [String] {
        return []
    }
    
    private func dropLast(_ str: String) -> String {
        String(str.dropLast())
    }
}
