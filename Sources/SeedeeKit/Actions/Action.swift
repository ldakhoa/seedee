//
//  File.swift
//  
//
//  Created by Khoa Le on 03/02/2023.
//

import Foundation

public protocol Action<Output> {
    associatedtype Output

    var name: String { get }
    func run() async throws -> Output
    func cleanUp(error: Error?) async throws
}

public extension Action {
    var name: String {
        "\(Self.self)"
    }

    func cleanUp(error: Error?) async throws {}
}
