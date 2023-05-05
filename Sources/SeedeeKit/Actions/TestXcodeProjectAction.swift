import Foundation

struct TestXcodeProjectAction: Action {
    public let name = "Test Xcode Project"

    private let project: Project
    private let destination: BuildOptions.Destination?
    private let testWithoutBuilding: Bool
    private let xcpretty: Bool
    private let executor: any Executor

    public init(
        project: Project,
        destination: BuildOptions.Destination? = nil,
        testWithoutBuilding: Bool = false,
        xcpretty: Bool = false,
        executor: any Executor = ProcessExecutor()
    ) {
        self.project = project
        self.destination = destination
        self.testWithoutBuilding = testWithoutBuilding
        self.xcpretty = xcpretty
        self.executor = executor
    }

    @discardableResult
    func run() async throws -> ExecutorResult {
        let buildCommand = try await buildCommand().command
        return try await executor.execute(buildCommand, workingDirectory: project.workingDirectory)
    }

    public func buildCommand() async throws -> CommandBuilder {
        let defaultDestination = "platform=iOS Simulator,name=iPhone 8"
        let destination = destination?.description ?? defaultDestination

        let xcodebuild = CommandBuilder("set -o pipefail && xcodebuild")
            .append(testWithoutBuilding ? "test-without-building" : "test")
            .append("-project", value: project.projectPath)
            .append("-workspace", value: project.workspacePath)
            .append("-scheme", value: project.scheme)
            .append("-destination", value: "\'\(destination)\'")
            .append("| xcpretty", flag: xcpretty)

        return xcodebuild
    }
}

public extension Action {
    func testXcodeProject(
        project: Project,
        destination: BuildOptions.Destination? = nil,
        testWithoutBuilding: Bool = false,
        xcpretty: Bool = false
    ) async throws {
        try await action(
            TestXcodeProjectAction(
                project: project,
                destination: destination,
                testWithoutBuilding: testWithoutBuilding,
                xcpretty: xcpretty
            )
        )
    }
}
