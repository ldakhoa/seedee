import Foundation

// swiftlint:disable line_length
/// An object that configures archive exporting.
public struct ExportArchiveOptions: Encodable {
    /// A boolean value that indicates whether to include bitcode in the app archive.
    let compileBitcode: Bool

    /// An option that will export locally or upload to Apple.
    let destination: Destination

    /// The method used to export the archive.
    let method: Method

    /// An option for the exportOptions.plist file used to specify the signing style to use when exporting an app.
    let signingStyle: SigningStyle

    /// An option for the `exportOptions.plist` file used to specify whether Swift symbols should be stripped from the binary when exporting an app.
    let stripSwiftSymbols: Bool

    /// The team id of the team that is used to sign the app.
    let teamID: String?

    /// A boolean value that indicates whether the package include symbols.
    let uploadSymbols: Bool

    /// A boolean value that indicates whether Xcode should manage the app's build number when uploading to App Store Connect.
    let manageAppVersionAndBuildNumber: Bool

    /// An optional key that can be used in the `exportOptions.plist` file to specify a different bundle identifier for the app that is being exported, as compared to the bundle identifier that is defined in your Xcode project.
    let distributionBundleIdentifier: String?

    /// A provisioning profile is a configuration file that includes information about the developer and the devices or simulators that are allowed to run the app. Xcode uses the provisioning profile to sign the app and to enable it to run on the intended devices.
    let provisioningProfiles: [String: String]?

    /// Containing information about the app archive, users can download app on the web by opening your distribution manifest file.
    let manifest: Manifest?

    /// An enum object that indicates whether Xcode thin the package for one or more device variants.
    let thinning: Thinning

    /// A signing certificate that can be used for code signing.
    let signingCertificate: SigningCertificate<SigningAutomaticType>?

    /// A signing certificate that can be used for code signing.
    let installerSigningCertificate: SigningCertificate<InstallerAutomaticType>?

    /// A boolean value that indicates whether the app download asset packs from the specified URL.
    let onDemandResourcesAssetPacksBaseURL: String?

    /// A boolean value that indicates Xcode generate App Store information for uploading with `iTMSTransporter`.
    let generateAppStoreInformation: Bool

    /// A boolean value that indicates the signing certificate that can be used for code signing.
    let embedOnDemandResourcesAssetPacksInBundle: Bool

    /// Available options vary depending on the type of provisioning profile used.
    let iCloudContainerEnvironment: String?

    /// Init the `ExportArchiveOptions`.
    /// - Parameters:
    ///   - compileBitcode: A boolean value that indicates whether to include bitcode in the app archive. Defaults to `True`
    ///   - destination: An option that will export locally or upload to Apple.
    ///   - method: The method used to export the archive.
    ///   - signingStyle: An option for the exportOptions.plist file used to specify the signing style to use when exporting an app.
    ///   - stripSwiftSymbols: An option for the `exportOptions.plist` file used to specify whether Swift symbols should be stripped from the binary when exporting an app. Defaults to `True`.
    ///   - teamID: The team id of the team that is used to sign the app.
    ///   - uploadSymbols: A boolean value that indicates whether the package include symbols.
    ///   - manageAppVersionAndBuildNumber: A boolean value that indicates whether. Defaults to `true`
    ///   Xcode should manage the app's build number when uploading to App Store Connect.
    ///   - distributionBundleIdentifier: An optional key that can be used in the `exportOptions.plist` file
    ///   to specify a different bundle identifier for the app that is being exported,
    ///   as compared to the bundle identifier that is defined in your Xcode project.
    ///   - provisioningProfiles: A provisioning profile is a configuration file.
    ///   that includes information about the developer and the devices or simulators that are allowed to run the app.
    ///   Xcode uses the provisioning profile to sign the app and to enable it to run on the intended devices.
    ///   - manifest: Containing information about the app archive, users can download app on the web by opening your distribution manifest file.
    ///   - thinning: An enum object that indicates whether Xcode thin the package for one or more device variants.
    ///   - signingCertificate: A signing certificate that can be used for code signing.
    ///   - installerSigningCertificate: A signing certificate that can be used for code signing.
    ///   - embedOnDemandResourcesAssetPacksInBundle: A signing certificate that can be used for code signing. Defaults to `true`.
    ///   - generateAppStoreInformation: A signing certificate that can be used for code signing. Defaults to `false`.
    ///   - onDemandResourcesAssetPacksBaseURL: A signing certificate that can be used for code signing.
    ///   - iCloudContainerEnvironment: Available options vary depending on the type of provisioning profile used.
    public init(
        compileBitcode: Bool = true,
        destination: Destination = .export,
        method: Method = .development,
        signingStyle: SigningStyle,
        stripSwiftSymbols: Bool = true,
        teamID: String? = nil,
        uploadSymbols: Bool = true,
        manageAppVersionAndBuildNumber: Bool = true,
        distributionBundleIdentifier: String? = nil,
        provisioningProfiles: [String: String]? = nil,
        manifest: Manifest? = nil,
        thinning: Thinning = .none,
        signingCertificate: SigningCertificate<SigningAutomaticType>?,
        installerSigningCertificate: SigningCertificate<InstallerAutomaticType>?,
        embedOnDemandResourcesAssetPacksInBundle: Bool = true,
        generateAppStoreInformation: Bool = false,
        onDemandResourcesAssetPacksBaseURL: String? = nil,
        iCloudContainerEnvironment: String? = nil
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
        self.provisioningProfiles = provisioningProfiles
        self.manifest = manifest
        self.thinning = thinning
        self.signingCertificate = signingCertificate
        self.installerSigningCertificate = installerSigningCertificate
        self.embedOnDemandResourcesAssetPacksInBundle = embedOnDemandResourcesAssetPacksInBundle
        self.generateAppStoreInformation = generateAppStoreInformation
        self.onDemandResourcesAssetPacksBaseURL = onDemandResourcesAssetPacksBaseURL
        self.iCloudContainerEnvironment = iCloudContainerEnvironment
    }

    // swiftlint:disable identifier_name
    /// Convenience init that support builtin `method`.
    /// - Parameters:
    ///   - method: The method used to export the archive.
    ///   - distribution: An enum representing the distribution type of the app.
    ///   - signing: An enumeration representing different types of built-in signing for an Xcode project.
    ///   - distributionBundleIdentifier: An optional key that can be used in the `exportOptions.plist` file to specify a different bundle identifier for the app that is being exported, as compared to the bundle identifier that is defined in your Xcode project.
    ///   - iCloudContainerEnvironment: Available options vary depending on the type of provisioning profile used.
    ///   - stripSwiftSymbols: An option for the `exportOptions.plist` file used to specify whether Swift symbols should be stripped from the binary when exporting an app.
    ///   - teamID: The team id of the team that is used to sign the app.
    public init(
        method: Method,
        distribution: Distribution,
        signing: BuiltInSigning,
        distributionBundleIdentifier: String? = nil,
        iCloudContainerEnvironment: String? = nil,
        stripSwiftSymbols: Bool = true,
        teamID: String? = nil
    ) {
        let compileBitcode: Bool
        let destination: Destination
        let embedOnDemandResourcesAssetPacksInBundle: Bool
        let generateAppStoreInformation: Bool
        let manageAppVersionAndBuildNumber: Bool
        let manifest: Manifest?
        let onDemandResourcesAssetPacksBaseURL: String?
        let thinning: Thinning
        let uploadSymbols: Bool

        switch distribution {
        case let .appStore(
            uploadToAppStore,
            _manageAppVersionAndBuildNumber,
            _generateAppStoreInformation,
            _uploadSymbols
        ):
            compileBitcode = true
            destination = uploadToAppStore ? .upload : .export
            embedOnDemandResourcesAssetPacksInBundle = true
            generateAppStoreInformation = _generateAppStoreInformation
            manageAppVersionAndBuildNumber = _manageAppVersionAndBuildNumber
            manifest = nil
            onDemandResourcesAssetPacksBaseURL = nil
            thinning = .none
            uploadSymbols = _uploadSymbols
        case let .nonAppStore(
            _manifest,
            _compileBitcode,
            onDemandResources,
            _thinning
        ):
            compileBitcode = _compileBitcode
            destination = .export
            embedOnDemandResourcesAssetPacksInBundle = onDemandResources?.embedOnDemandResourcesAssetPacksInBundle ?? true
            generateAppStoreInformation = false
            manageAppVersionAndBuildNumber = false
            manifest = _manifest
            onDemandResourcesAssetPacksBaseURL = onDemandResources?.onDemandResourcesAssetPacksBaseURL
            thinning = _thinning
            uploadSymbols = false
        }

        let installerSigningCertificate: SigningCertificate<InstallerAutomaticType>?
        let provisioningProfiles: [String: String]?
        let signingCertificate: SigningCertificate<SigningAutomaticType>?
        let signingStyle: SigningStyle

        switch signing {
        case .automatic:
            installerSigningCertificate = nil
            provisioningProfiles = nil
            signingCertificate = nil
            signingStyle = .automatic
        case let .manual(_provisioningProfiles, additionalSigningOptions):
            provisioningProfiles = _provisioningProfiles
            installerSigningCertificate = additionalSigningOptions?.installerSigningCertificate
            signingCertificate = additionalSigningOptions?.signingCertificate
            signingStyle = .manual
        }

        self.init(
            compileBitcode: compileBitcode,
            destination: destination,
            method: method,
            signingStyle: signingStyle,
            stripSwiftSymbols: stripSwiftSymbols,
            teamID: teamID,
            uploadSymbols: uploadSymbols,
            manageAppVersionAndBuildNumber: manageAppVersionAndBuildNumber,
            distributionBundleIdentifier: distributionBundleIdentifier,
            provisioningProfiles: provisioningProfiles,
            manifest: manifest,
            thinning: thinning,
            signingCertificate: signingCertificate,
            installerSigningCertificate: installerSigningCertificate,
            embedOnDemandResourcesAssetPacksInBundle: embedOnDemandResourcesAssetPacksInBundle,
            generateAppStoreInformation: generateAppStoreInformation,
            onDemandResourcesAssetPacksBaseURL: onDemandResourcesAssetPacksBaseURL,
            iCloudContainerEnvironment: iCloudContainerEnvironment
        )
    }
}

extension ExportArchiveOptions {
    func buildPropertyList() throws -> Data {
        try PropertyListEncoder().encode(self)
    }
}

extension ExportArchiveOptions {
    /**
     An enum representing the type of on-demand resources.

     - `embed`: On-demand resources are embedded in the app bundle.
     - `remote`: On-demand resources are downloaded from a remote server.

     This enum is used as a parameter in the `SeedeeDistribution` enum.
     */
    public enum OnDemandResources {

        /// On-demand resources are embedded in the app bundle.
        case embed

        /// On-demand resources are downloaded from a remote server.
        /// - Parameter baseURL: The base URL of the server from which to download on-demand resources.
        case remote(baseURL: String)

        /// Returns a boolean value indicating whether on-demand resources should be embedded in the app bundle.
        var embedOnDemandResourcesAssetPacksInBundle: Bool {
            switch self {
            case .embed:
                return true
            case .remote:
                return false
            }
        }

        /// Returns the base URL of the server from which to download on-demand resources.
        var onDemandResourcesAssetPacksBaseURL: String? {
            switch self {
            case .embed:
                return nil
            case let .remote(baseURL):
                return baseURL
            }
        }
    }

    /**
     An enum representing the distribution type of the app.

     - `appstore`: App is distributed through the App Store.
     - `nonAppStore`: App is distributed outside the App Store.

     This enum is used as a parameter in the `Seedee` object.
     */
    public enum Distribution {

        /// App is distributed through the App Store.
        /// - Parameters:
        ///   - uploadToAppStore: Whether to upload the app to the App Store.
        ///   - manageAppVersionAndBuildNumber: Whether to manage the app version and build number.
        ///   - generateAppStoreInformation: Whether to generate App Store information.
        ///   - uploadSymbols: Whether to upload symbols.
        case appStore(
            uploadToAppStore: Bool,
            manageAppVersionAndBuildNumber: Bool = true,
            generateAppStoreInformation: Bool = false,
            uploadSymbols: Bool = true
        )

        /// App is distributed outside the App Store.
        /// - Parameters:
        ///   - manifest: Containing information about the app archive, users can download app on the web by opening your distribution manifest file..
        ///   - compileBitcode: Whether to compile bitcode.
        ///   - onDemandResources: The type of on-demand resources to use.
        ///   - thinning: An enum object that indicates whether Xcode thin the package for one or more device variants.
        case nonAppStore(
            manifest: Manifest,
            compileBitcode: Bool = true,
            onDemandResources: OnDemandResources? = nil,
            thinning: Thinning = .none
        )
    }

    /// An enumeration representing different types of built-in signing for an Xcode project.
    public enum BuiltInSigning {

        /// Automatic signing.
        case automatic

        /// Manual signing.
        case manual(
            provisioningProfile: [String: String],
            additionalSigningOptions: AdditionalSigningOptions?
        )

        /// Additional signing options.
        public struct AdditionalSigningOptions {

            /// Signing certificate.
            let signingCertificate: SigningCertificate<SigningAutomaticType>?

            /// Installer signing certificate.
            let installerSigningCertificate: SigningCertificate<InstallerAutomaticType>?

            /// Initializes an instance of `AdditionalSigningOptions`.
            ///
            /// - Parameters:
            ///   - signingCertificate: The signing certificate.
            ///   - installerSigningCertificate: The installer signing certificate.
            public init(
                signingCertificate: SigningCertificate<SigningAutomaticType>? = nil,
                installerSigningCertificate: SigningCertificate<InstallerAutomaticType>? = nil
            ) {
                self.signingCertificate = signingCertificate
                self.installerSigningCertificate = installerSigningCertificate
            }
        }
    }
}

extension ExportArchiveOptions {
    /// An option that will export locally or upload to Apple.
    public enum Destination: String, Encodable {
        case export
        case upload
    }

    /// The method used to export the archive.
    public enum Method: String, Encodable {
        case adHoc = "ah-hoc"
        case package
        case enterprise
        case development
        case developerID = "developer-id"
        case macApplication = "mac-application"
    }

    /// A signing certificate that can be used for code signing.
    ///
    /// There are three cases:
    /// - certificate: The certificate's name.
    /// - sha1: The certificate's SHA-1 hash.
    /// - automatic: The certificate is automatically selected using the given type.
    public enum SigningCertificate<Type: RawRepresentable<String>>: Encodable {
        /// The certificate's name.
        case certificate(name: String)

        /// The certificate's SHA-1 hash.
        case sha1(hash: String)

        /// The certificate is automatically selected using the given type.
        case automatic(type: Type)

        /// Encodes the signing certificate.
        ///
        /// - Parameters:
        ///   - encoder: The encoder to use.
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .certificate(let name):
                try container.encode(name)
            case .sha1(let hash):
                try container.encode(hash)
            case .automatic(let type):
                try container.encode(type.rawValue)
            }
        }
    }

    /// The type of automatic signing certificate to use.
    public enum SigningAutomaticType: String, Encodable {
        /// A Mac App Distribution certificate.
        case macAppDistribution = "Mac App Distribution"

        /// An iOS Distribution certificate.
        case iOSDistribution = "iOS Distribution"

        /// An iOS Developer certificate.
        case iOSDeveloper = "iOS Developer"

        /// A Developer ID Application certificate.
        case developerIDApplication = "Developer ID Application"

        /// An Apple Distribution certificate.
        case appleDistribution = "Apple Distribution"

        /// A Mac Developer certificate.
        case macDeveloper = "Mac Developer"

        /// An Apple Development certificate.
        case appleDevelopment = "Apple Development"
    }

    public enum InstallerAutomaticType: String {
        case macInstallterDistribution = "Mac Installer Distribution"
        case developerIDInstaller = "Developer ID Installer"
    }

    /// An enum object that indicates whether Xcode thin the package for one or more device variants.
    public enum Thinning: Encodable {
        /// No thinning should be applied.
        case none

        /// All possible thinning should be applied.
        case thinForAllVariants

        /**
         The app should be thinned for a specific device.

         - Parameter deviceIdentifier: The identifier of the device for which to thin the app.
         */
        case thin(deviceIdentifier: String)

        /// Encodes the receiver using the given encoder.
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .none:
                try container.encode("<none>")
            case .thinForAllVariants:
                try container.encode("<thin-for-all-variants>")
            case .thin(let deviceIdentifier):
                try container.encode(deviceIdentifier)
            }
        }
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
    public enum SigningStyle: String, Encodable {
        case automatic
        case manual
    }

    /// Containing information about the app archive, users can download app on the web by opening your distribution manifest file.
    ///
    /// When exporting your app for non-App Store distribution,
    /// you can include a distribution manifest file that contains information about your app,
    /// such as the download URL, the display image, and the full-size image.
    /// The manifest file is typically hosted on a web server, and users can download the file by opening its URL in a web browser.
    public struct Manifest: Encodable {
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
