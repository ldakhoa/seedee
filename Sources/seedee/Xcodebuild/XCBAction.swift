import Foundation

protocol XCBActionProtocol {
    func run(argument: Args)
}

class XCBAction: XCBActionProtocol {
    func run(argument: Args) {
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
            Logger.shared.log(type: .error, message: error.localizedDescription)
        }
    }
}
