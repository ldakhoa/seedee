import Foundation

struct CocoaPodsRunner {
    private let metadata = Metadata()
    private let shell = SeedeeShell.shared
    
    func prepareCocoaPods(options: CocoaPodsOption) {
        switch options {
        case .install:
            podInstall()
        }
    }

    func podInstall() {
        pod("install")
    }
    
    private func pod(_ cmd: String) {
        guard let program = metadata.resolveProgram(name: "pod ") else { return }
        do {
            let output = try shell.run(program + cmd, logCommand: true)
            print(output)
        } catch {
            Logger.shared.log(type: .error, message: error.localizedDescription)
        }
    }
}

extension CocoaPodsRunner {
    enum CocoaPodsOption {
        case install
    }
}
