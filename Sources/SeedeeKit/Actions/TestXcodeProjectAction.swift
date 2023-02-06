import Foundation

public struct TestXcodeProjectAction: Action {
    public let name = "Test Xcode Project"

    private let project: String?
    private let workspace: String?
    private let scheme: String?
    private let destination: BuildOptions.Destination?
    private let testWithoutBuilding: Bool
    private let workingDirectory: String?

    public init(
        project: String? = nil,
        workspace: String? = nil,
        scheme: String? = nil,
        destination: BuildOptions.Destination? = nil,
        testWithoutBuilding: Bool = false,
        workingDirectory: String? = nil
    ) {
        self.project = project
        self.workspace = workspace
        self.scheme = scheme
        self.destination = destination
        self.testWithoutBuilding = testWithoutBuilding
        self.workingDirectory = workingDirectory
    }

    public func run() async throws -> String {
        let defaultDestination = "platform=iOS Simulator,name=iPhone 14"
        let destination = destination?.description ?? defaultDestination

        let testCommand = CommandBuilder("xcodebuild")
            .append(testWithoutBuilding ? "test-without-building" : "test")
            .append("-project", value: project)
            .append("-workspace", value: workspace)
            .append("-scheme", value: scheme)
            .append("-destination", value: "\'\(destination)\'")

        return try executor.shell(testCommand, workingDirectory: workingDirectory)
    }
}

public extension Action {
    @discardableResult
    func testXcodeProject(
        project: String? = nil,
        scheme: String? = nil,
        destination: BuildOptions.Destination? = nil,
        testWithoutBuilding: Bool = false
    ) async throws -> String {
        try await action(TestXcodeProjectAction(
            project: project,
            scheme: scheme,
            destination: destination,
            testWithoutBuilding: testWithoutBuilding
        ))
    }
}
