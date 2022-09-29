import Foundation
import ColorizeSwift

final class Logger {
    static let shared = Logger()
    
    var currentTime: String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        return "\(hour):\(minutes):\(seconds)"
    }
    
    func log(type: LoggerType, message: String) {
        let str = makeColor(type: type, message: "[\(currentTime)] [\(type.description)] \(message)")
        print(str)
    }
    
    private func makeColor(type: LoggerType, message: String) -> String {
        switch type {
        case .debug:
            return message.white()
        case .info:
            return message.green()
        case .warning:
            return message.yellow()
        case .error:
            return message.red()
        case .critical:
            return message.bold().red()
        }
    }
}

extension Logger {
    enum LoggerType: CustomStringConvertible {
        case debug
        case info
        case warning
        case error
        case critical
        
        var description: String {
            switch self {
            case .debug:
                return "DEBUG"
            case .info:
                return "INFO"
            case .warning:
                return "WARNING"
            case .error:
                return "ERROR"
            case .critical:
                return "CRITICAL"
            }
        }
    }
}
