import Foundation
import Glob
import ColorizeSwift

struct Metadata {
    private let fileManager = FileManager.default
    private let fileExtension = FileExtension.shared
    
    private var currentPath: String {
        fileManager.currentDirectoryPath
    }
    
    var xcodeprojPath: String? {
        guard validatePath(fileExtension: fileExtension.xcodeproj) else { return nil }
        
        let files = Glob(pattern: "\(currentPath)/*\(fileExtension.xcodeproj)")
        
        if files.count > 1 {
            Logger.shared.log(type: .warning, message: "Multiple Xcode projects are detected")
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
    
    func resolveProgram(name: String) -> String? {
        if validateBundle() {
            return "bundle exec \(name)"
        }
        return nil
    }
    
    func defaultDerivedData() -> String? {
        var cmd = "xcodebuild -showBuildSettings"
        guard
            let xcworkspacePath = xcworkspacePath,
            let scheme = scheme
        else {
            return ""
        }
        
        if xcworkspacePath.isEmpty {
            cmd += " -workspace \(xcworkspacePath)"
            cmd += " -scheme \(scheme)"
        }
        
        do {
            let content = try SeedeeShell.shared.run(cmd)
            // search for /var/root/Library/Developer/Xcode/DerivedData/TargetName-abcxyz...
            let range = NSRange(location: 0, length: content.count)
            let result = try NSRegularExpression(pattern: "BUILD_ROOT = (.*)")
                .matches(in: content, range: range)
                .compactMap {
                    Range($0.range, in: content)
                        .flatMap {
                            String(content[$0])
                        }
                }
            return result[0]
        } catch {
            Logger.shared.log(type: .error, message: error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Private
    
    private var schemes: [String] {
        let files = Glob(pattern: "\(currentPath)/*.xcodeproj/xcshareddata/xcschemes/*.xcscheme")
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
            let enumerator = fileManager.enumerator(atPath: currentPath)?.allObjects as? [String]
        else {
            return false
        }
    
        let validateExtension = enumerator.filter { $0.contains(fileExtension) }
        
        return validateExtension.isEmpty ? false : true
    }
    
    private func validateBundle() -> Bool {
        guard let enumerator = fileManager.enumerator(atPath: currentPath)?.allObjects as? [String] else { return false }
        let validate = enumerator.filter { $0.contains("Gemfile") }.isEmpty
        return !validate
    }
}
