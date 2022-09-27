import Foundation

protocol XCBAction {
    func run(argument: String)
}

extension XCBAction {
    func run(argument: String) {
        let metadata = Metadata()
        let makers: [CmdMaker] = [
            XCBCmdMaker(metadata: metadata, argument: argument),
            TeeCmdMaker(metadata: metadata, argument: argument),
            LogCmdMaker(metadata: metadata, argument: argument)
        ]
        
        var commands = ""
        
        makers.forEach {
            guard
                let strMakes = $0.make(),
                !strMakes.isEmpty
            else {
                return
            }
            
            commands += strMakes[0]
        }
        
        Logger.shared.log(type: .info, message: commands)
        
        do {
            let output = try SeedeeProcess.shared.run(commands)
            print(output)
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct XCBBuildAction: XCBAction {}

struct XCBTestAction: XCBAction {}
