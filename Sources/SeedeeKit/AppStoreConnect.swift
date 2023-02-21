import AppStoreConnect_Swift_SDK

extension APIConfiguration {
    /// The custom object that needed to set up the API Provider including all needed information for performing API requests.
    public struct Key {
        /// Your private key ID from App Store Connect (Ex: 2X9R4HXF34).
        let privateKeyID: String

        /// Your issuer ID from the API Keys page in App Store Connect (Ex: 57246542-96fe-1a63-e053-0824d011072a).
        let issuerID: String

        let privateKey: String

        /// The path that contains the p12 file to read `privateKey`.
        let path: String?

        /// Creates a new API configuration to use for initialising the API Provider.
        ///
        /// - Parameters:
        ///   - privateKeyID: Your private key ID from App Store Connect (Ex: 2X9R4HXF34).
        ///   - issuerID: /// Your issuer ID from the API Keys page in App Store Connect (Ex: 57246542-96fe-1a63-e053-0824d011072a).
        ///   - privateKey: The private key that needs to interact with AppStoreConnect API.
        ///   - path: /// The path that contains the p8 file to read `privateKey`.
        public init(
            privateKeyID: String,
            issuerID: String,
            privateKey: String,
            path: String?
        ) {
            self.privateKeyID = privateKeyID
            self.issuerID = issuerID
            self.privateKey = privateKey
            self.path = path
        }
    }
}
