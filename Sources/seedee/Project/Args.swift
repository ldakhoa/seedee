import Foundation

struct Args {
    let xctestrun: String?
    let workspace: String?
    let scheme: String?
    let project: String?
    let target: String?
    let actions: [String]?
    let sdk: String?
    let derivedDataPath: String?
    let configuration: String?
    let destination: String?
    
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
