import Foundation
import OrderedCollections

public struct BuildOptions {
    var buildConfiguration: BuildConfiguration
    var sdks: OrderedSet<SDK>

    init(buildConfiguration: BuildConfiguration, sdks: OrderedSet<SDK>) {
        self.buildConfiguration = buildConfiguration
        self.sdks = sdks
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
            return "generic/platform=iOS Simulator"
        case .iOS:
            return "generic/platform=iOS"
        case .macOS:
            return "generic/platform=macOS,name=Any Mac"
        }
    }
}
