import Foundation

final class SeedeeProcess {
    static let shared = SeedeeProcess()
    
    @discardableResult
    func run(_ command: String, logCommand: Bool = false) throws -> String {
        let task = Process()
        let pipe = Pipe()
        
        if logCommand {
            Logger.shared.log(type: .info, message: "$ \(command)")
        }
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.standardInput = nil
        
        try task.run()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? "Cannot execute"
        
        return output
    }
}
