import Foundation

final class Arguments {
    var xctestrun: String?
    var workspace: String?
    var scheme: String?
    var project: String?
    var target: String?
    var actions: [String]?
    var sdk: String?
    var derivedDataPath: String?
    var configuration: String?
    var destination: String?
    
    init(
        xctestrun: String? = nil,
        workspace: String? = nil,
        scheme: String? = nil,
        project: String? = nil,
        target: String? = nil,
        actions: [String]? = nil,
        sdk: String? = nil,
        derivedDataPath: String? = nil,
        configuration: String? = nil,
        destination: String? = nil
    ) {
        self.xctestrun = xctestrun
        self.workspace = workspace
        self.scheme = scheme
        self.project = project
        self.target = target
        self.actions = actions
        self.sdk = sdk
        self.derivedDataPath = derivedDataPath
        self.configuration = configuration
        self.destination = destination
    }
}
