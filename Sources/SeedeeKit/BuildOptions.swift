import Foundation

public struct BuildOptions {
    var buildConfiguration: BuildConfiguration
    var sdk: SDK

    init(buildConfiguration: BuildConfiguration, sdks: SDK) {
        self.buildConfiguration = buildConfiguration
        self.sdk = sdks
    }
}

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

public enum SDK: String, Codable {
    case iOSSimulator
    case iOS
    case macOS

    var destination: String {
        switch self {
        case .iOSSimulator:
            return "platform=iOS Simulator"
        case .iOS:
            return "platform=iOS"
        case .macOS:
            return "platform=macOS,name=Any Mac"
        }
    }
}
