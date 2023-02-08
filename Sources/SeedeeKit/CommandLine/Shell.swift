//import Foundation
//
//public struct Shell {
////    @ExecutorWrapper(\.fileManager) var fileManager
//
//    @discardableResult
//    public func callAsFunction(
//        _ builder: CommandBuilder,
//        workingDirectory: String? = nil,
//        log: Bool = true,
//        quiet: Bool = false
//    ) throws -> String {
//        let currentDirectory = workingDirectory ?? fileManager.currentDirectoryPath
//
//        let command = builder.command
//
//        if logger.logLevel == .trace {
//            logger.debug("Info: \(command) at: \(currentDirectory)")
//        } else if log {
//            logger.debug("Info: \(command)")
//        }
//
//        let commandLine = CommandLine(command: command, workingDirectory: currentDirectory)
//        let output = try commandLine.launch()
//
//        if !quiet {
//            print(output)
//        }
//
//        return output
//    }
//}
//
//extension TaskExecutor {
//    enum ShellKey: ExecutorKey {
//        static var defaultValue = Shell()
//    }
//
//    public var shell: Shell {
//        get {
//            self[ShellKey.self]
//        }
//        set {
//            self[ShellKey.self] = newValue
//        }
//    }
//}
