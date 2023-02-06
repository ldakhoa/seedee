import Foundation

public struct TestXcodeProjectAction: Action {
    public let name = "Test Xcode Project"

    private let project: String?
    private let scheme: String?
    private let buildOptions: BuildOptions?
    private let testWithoutBuilding: Bool

    init(
        project: String? = nil,
        scheme: String? = nil,
        buildOptions: BuildOptions? = nil,
        testWithoutBuilding: Bool = false
    ) {
        self.project = project
        self.scheme = scheme
        self.buildOptions = buildOptions
        self.testWithoutBuilding = testWithoutBuilding
    }

    public func run() async throws -> String {
        let defaultDestination = "platform=iOS Simulator,name=iPhone 14"
        let destination = buildOptions?.sdk.destination ?? defaultDestination

        let testCommand = CommandBuilder("xcodebuild")
            .append(testWithoutBuilding ? "test-without-building" : "test")
            .append("-project", value: project)
            .append("-scheme", value: scheme)
            .append("-destination", value: "\'\(destination)\'")
            .append("-configuration", value: buildOptions?.buildConfiguration.settingsValue)

        return try executor.shell(testCommand)
    }
}

public extension Action {
    @discardableResult
    func testXcodeProject(
        project: String? = nil,
        scheme: String? = nil,
        buildOptions: BuildOptions? = nil,
        testWithoutBuilding: Bool = false
    ) async throws -> String {
        try await action(TestXcodeProjectAction(
            project: project,
            scheme: scheme,
            buildOptions: buildOptions,
            testWithoutBuilding: testWithoutBuilding
        ))
    }
}
