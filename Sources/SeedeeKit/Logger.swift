import Foundation
import Logging
import Rainbow

private(set) var logger = Logger(label: "com.ldakhoa.Seedee")

extension Logger {
    func error(_ error: Error) {
        if let error = error as? LocalizedError, let description = error.errorDescription {
            self.error("❌ \(description)", metadata: .color(.red))
        } else {
            self.error("❌ \(error.localizedDescription)", metadata: .color(.red))
        }
    }

    func error(_ error: String) {
        self.error("❌ \(error)", metadata: .color(.red))
    }
}

struct SeedeeLogHandler: LogHandler {
     var logLevel: Logger.Level = .info
     var metadata = Logger.Metadata()

     subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
         get {
             return self.metadata[metadataKey]
         }
         set {
             self.metadata[metadataKey] = newValue
         }
     }

     init() { }

     func log(level: Logger.Level,
              message: Logger.Message,
              metadata: Logger.Metadata?,
              source: String,
              file: String,
              function: String,
              line: UInt) {
         let color: NamedColor?
         if let metadata = metadata,
             let rawColorString = metadata["color"],
             let colorCode = UInt8(rawColorString.description),
             let namedColor = NamedColor(rawValue: colorCode) {
             color = namedColor
         } else {
             color = nil
         }
         if let color = color {
             print(message.description.applyingColor(color))
         } else {
             print(message.description)
         }
     }
 }

 extension LoggingSystem {
     public static func bootstrap() {
         self.bootstrap { _ in
             SeedeeLogHandler()
         }
     }
 }

// MARK: - Helpers

extension Logger.MetadataValue {
    static func color(_ color: NamedColor) -> Self {
        .stringConvertible(color.rawValue)
    }
}

extension Logger.Metadata {
    static func color(_ color: NamedColor) -> Self {
        ["color": .color(color)]
    }
}
