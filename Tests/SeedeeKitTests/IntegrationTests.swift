//
//  File.swift
//  
//
//  Created by Khoa Le on 08/02/2023.
//

import Foundation
import XCTest
@testable import SeedeeKit

final class IntegrationTests: XCTestCase {
    private static var integrationTestsEnabled: Bool {
        if let value = ProcessInfo.processInfo.environment["ENABLE_INTEGRATION_TESTS"], !value.isEmpty {
            return true
        }
        return false
    }

    override func setUp() async throws {
        try XCTSkipUnless(Self.integrationTestsEnabled)
        try await super.setUp()
    }

    func test_buildXcodeProject() async throws {
    }

    func test_testXcodeProject() async throws {
    }
}
