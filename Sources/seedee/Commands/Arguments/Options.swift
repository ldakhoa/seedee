import ArgumentParser

struct Options: ParsableArguments {
    @Flag(name: [.long], help: "")
    var buildForTesting: Bool = false
    
    @Flag(name: [.long], help: "")
    var testWithoutBuilding: Bool = false
}
