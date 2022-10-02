import Foundation

protocol XCBActivity {
    func run(arguments: Arguments)
}

class XCBAction: XCBActivity {
    let metadata = Metadata()
    
    func run(arguments: Arguments) {
        let makers: [CmdMaker] = [
            XCBCmdMaker(metadata: metadata, arguments: arguments),
            LogCmdMaker(metadata: metadata, arguments: arguments),
            TeeCmdMaker(metadata: metadata, arguments: arguments)
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
        
        Logger.shared.log(type: .info, message: "$ \(commands)")
        
        do {
            let output = try SeedeeShell.shared.run(commands)
            print(output)
        } catch {
            Logger.shared.log(type: .error, message: error.localizedDescription)
        }
    }
}
