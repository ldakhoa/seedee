# Seedee

⚠️ This project is currently under development. Feedbacks and pull requests are welcome.

Seedee is a Continuous Integration and Continuous Deployment (CI/CD) tool written in Swift that simplifies and automates the app distribution process for iOS and macOS applications. Seedee automates tasks like building, testing, and deploying, and supports various integrations like Git, Xcode among others.

## Features (WIP)

For further features, check out the [roadmap](./docs/ROADMAP.md).

- Automated builds and deployments of iOS and macOS applications
- Test automation
- Code signing and app provisioning
- Integration with popular SDKs, distribution platforms, and bug trackers
- Slack and email notifications for build/test results and deployment status
- And more...

## Usage

Create `Seedee.swift` file in your root project, then write your actions.

```swift
@main
struct Seedee: SeedeeFile {
    func run() async throws -> Void {
        let project = Project(projectPath: "GistHub.xcproj", scheme: "GistHub")

        try await buildXcodeProject(project: project)
        try await testXcodeProject(project: project)
        exportArchiveXcodeProjectAction(
            project,
            archivePath: "path/to/your/archive",
            exportOptions: "path/to/exportoptions",
            allowProvisioningUpdates: true
        )
    }
}
```

To learn how to use Seedee in your project, check out the documentation (WIP).

## Contributing

TBD

## License

Seedee is released under the [MIT License](./LICENSE).
