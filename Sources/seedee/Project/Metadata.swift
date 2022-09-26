import Foundation
import Glob
import ColorizeSwift

struct Metadata {
    private let fileManager = FileManager.default
    private let fileExtension = FileExtension.shared
    
    private var path: String {
        fileManager.currentDirectoryPath
    }
    
    var xcodeprojPath: String? {
        guard validatePath(fileExtension: fileExtension.xcodeproj) else { return nil }
        
        let files = Glob(pattern: "\(path)/*\(fileExtension.xcodeproj)")
        
        if files.count > 1 {
            print("warning:".bold().yellow(), "Multiple xcode projects are detected")
        }
        
        return lastFileName(files: files)[0]
    }
    
    var xcworkspacePath: String? {
        guard validatePath(fileExtension: fileExtension.xcworkspace) else { return nil }
        
        let files = Glob(pattern: "*\(fileExtension.xcworkspace)")
        return lastFileName(files: files)[0]
    }
    
    var projectName: String? {
        guard let xcodeprojPath = xcodeprojPath else { return nil }
        return URL(string: xcodeprojPath)?
            .deletingPathExtension()
            .lastPathComponent
    }
    
    var scheme: String? {
        !schemes.isEmpty ? schemes[0] : nil
    }
    
    // MARK: - Private
    
    private var schemes: [String] {
        let files = Glob(pattern: "\(path)/*.xcodeproj/xcshareddata/xcschemes/*.xcscheme")
        return lastFileName(files: files, withExtension: true)
    }
    
    private func lastFileName(files: Glob, withExtension: Bool = false) -> [String] {
        return files.compactMap {
            if withExtension {
                return URL(string: $0)?
                    .deletingPathExtension()
                    .lastPathComponent
            } else {
                return URL(string: $0)?
                    .lastPathComponent
            }
        }
    }
    
    private func validatePath(fileExtension: String) -> Bool {
        guard
            let enumerator = fileManager.enumerator(atPath: path)?.allObjects as? [String]
        else {
            return false
        }
    
        let validateExtension = enumerator.filter { $0.contains(fileExtension) }
        
        return validateExtension.isEmpty ? false : true
    }
}
