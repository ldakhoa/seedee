import Foundation

/// An object that configures archive exporting.
public struct ExportArchiveOptions: Codable {
    /// A boolean value that indicates whether to include bitcode in the app archive.
    let compileBitcode: Bool

    /// An option that will export locally or upload to Apple.
    let destination: Destination

    /// The method used to export the archive.
    let method: Method

    /// An option for the exportOptions.plist file used to specify the signing style to use when exporting an app.
    let signingStyle: SigningStyle

    /// `stripSwiftSymbols` is an option for the `exportOptions.plist` file
    /// used to specify whether Swift symbols should be stripped from the binary when exporting an app.
    let stripSwiftSymbols: Bool

    /// The team id of the team that is used to sign the app.
    let teamID: String?

    /// A boolean value that indicates whether the package include symbols.
    let uploadSymbols: Bool

    /// A boolean value that indicates whether Xcode should manage the app's build number when uploading to App Store Connect.
    let manageAppVersionAndBuildNumber: Bool

    /// An optional key that can be used in the `exportOptions.plist` file
    /// to specify a different bundle identifier for the app that is being exported,
    /// as compared to the bundle identifier that is defined in your Xcode project.
    let distributionBundleIdentifier: String?

    /// A provisioning profile is a configuration file that includes information about the developer
    /// and the devices or simulators that are allowed to run the app.
    /// Xcode uses the provisioning profile to sign the app and to enable it to run on the intended devices.
    let provisinioningProfile: [String: String]?

    /// Containing information about the app archive, users can download app on the web by opening your distribution manifest file.
    let manifest: Manifest?

    /// Init the `ExportArchiveOptions`.
    /// - Parameters:
    ///   - compileBitcode: A boolean value that indicates whether to include bitcode in the app archive.
    ///   - destination: An option that will export locally or upload to Apple.
    ///   - method: The method used to export the archive.
    ///   - signingStyle: An option for the exportOptions.plist file used to specify the signing style to use when exporting an app.
    ///   - stripSwiftSymbols:An option for the `exportOptions.plist` file
    ///   used to specify whether Swift symbols should be stripped from the binary when exporting an app.
    ///   - teamID: The team id of the team that is used to sign the app.
    ///   - uploadSymbols: A boolean value that indicates whether the package include symbols.
    ///   - manageAppVersionAndBuildNumber: A boolean value that indicates whether
    ///   Xcode should manage the app's build number when uploading to App Store Connect.
    ///   - distributionBundleIdentifier: An optional key that can be used in the `exportOptions.plist` file
    ///   to specify a different bundle identifier for the app that is being exported,
    ///   as compared to the bundle identifier that is defined in your Xcode project.
    ///   - provisinioningProfile: A provisioning profile is a configuration file
    ///   that includes information about the developer and the devices or simulators that are allowed to run the app.
    ///   Xcode uses the provisioning profile to sign the app and to enable it to run on the intended devices.
    ///   - manifest: Containing information about the app archive, users can download app on the web by opening your distribution manifest file.
    public init(
        compileBitcode: Bool,
        destination: Destination,
        method: Method,
        signingStyle: SigningStyle,
        stripSwiftSymbols: Bool,
        teamID: String?,
        uploadSymbols: Bool,
        manageAppVersionAndBuildNumber: Bool,
        distributionBundleIdentifier: String?,
        provisinioningProfile: [String: String]?,
        manifest: Manifest?
    ) {
        self.compileBitcode = compileBitcode
        self.destination = destination
        self.method = method
        self.signingStyle = signingStyle
        self.stripSwiftSymbols = stripSwiftSymbols
        self.teamID = teamID
        self.uploadSymbols = uploadSymbols
        self.manageAppVersionAndBuildNumber = manageAppVersionAndBuildNumber
        self.distributionBundleIdentifier = distributionBundleIdentifier
        self.provisinioningProfile = provisinioningProfile
        self.manifest = manifest
    }
}

extension ExportArchiveOptions {
    func buildPropertyList() throws -> Data {
        try PropertyListEncoder().encode(self)
    }
}

extension ExportArchiveOptions {
    /// An option that will export locally or upload to Apple.
    public enum Destination: String, Codable {
        case export
        case upload
    }

    /// The method used to export the archive.
    public enum Method: String, Codable {
        case adHoc = "ah-hoc"
        case package
        case enterprise
        case development
        case developerID = "developer-id"
        case macApplication = "mac-application"
    }

    /// An option for the exportOptions.plist file used to specify the signing style to use when exporting an app.
    ///
    /// **`manual`**: This signing style requires you to manually specify the signing identity to use for code signing.
    /// You can do this by setting the signingCertificate key to the full name of the distribution certificate that you want to use,
    /// or by specifying the path to a custom signing certificate using the signingCertificate key.
    ///
    /// **`automatic`**: This signing style uses Xcode's automatic signing feature
    /// to automatically select the best signing identity based on the provisioning profiles that are available for the app.
    ///
    /// When using the manual signing style,
    /// you'll need to make sure that you have the distribution certificate installed in your keychain
    /// and that you provide the correct name of the certificate in the signingCertificate key.
    ///
    /// When using the automatic signing style,
    /// Xcode will automatically select the best signing identity based on the provisioning profiles that are available for the app.
    /// You'll need to make sure that you have the correct provisioning profiles installed and that they are up-to-date.
    public enum SigningStyle: String, Codable {
        case automatic
        case manual
    }

    /// Containing information about the app archive, users can download app on the web by opening your distribution manifest file.
    ///
    /// When exporting your app for non-App Store distribution,
    /// you can include a distribution manifest file that contains information about your app,
    /// such as the download URL, the display image, and the full-size image.
    /// The manifest file is typically hosted on a web server, and users can download the file by opening its URL in a web browser.
    public struct Manifest: Codable {
        let appURL: String
        let displayImageURL: String
        let fullSizeImageURL: String
        let assetPackManifestURL: String?

        /// Init the `Manifest` object.
        /// - Parameters:
        ///   - appURL: The download URL for your app. This should be a direct link to the IPA file that users can download to install your app.
        ///   - displayImageURL: The URL of the image that will be displayed in the App Store or in the user's device when the app is being installed.
        ///   - fullSizeImageURL: The URL of the full-size image that will be displayed in the App Store
        ///   or in the user's device when the app is being installed.
        ///   - assetPackManifestURL: The URL of the asset pack manifest file to using on-demand resources.
        init(
            appURL: String,
            displayImageURL: String,
            fullSizeImageURL: String,
            assetPackManifestURL: String? = nil
        ) {
            self.appURL = appURL
            self.displayImageURL = displayImageURL
            self.fullSizeImageURL = fullSizeImageURL
            self.assetPackManifestURL = assetPackManifestURL
        }
    }
}
