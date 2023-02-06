import Foundation

public enum BuildOptions {
    public enum BuildConfiguration: String, Codable {
        case debug
        case release

        var settingsValue: String {
            switch self {
            case .debug: return "Debug"
            case .release: return "Release"
            }
        }
    }

    public enum Destination: CustomStringConvertible {
        case iOSSimulator
        case iOS
        case custom(_ destination: String)

        public var description: String {
            switch self {
            case .iOSSimulator:
                return "platform=iOS Simulator"
            case .iOS:
                return "platform=iOS"
            case let .custom(destination):
                return destination
            }
        }
    }
}
