import Foundation

public protocol SeedeeFile: Action {
    init()
}

extension SeedeeFile {
    public static func main() async {
        do {
            let runner = self.init()
            try await runner.action(runner)
        } catch {

        }

    }
}
