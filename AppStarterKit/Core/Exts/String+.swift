//
//  String+.swift
//  AppStarterKit
//
//  Created by Chanchana on 28/3/2568 BE.
//

import Foundation

public extension String {
    /// SwifterSwift: Convert JSON string to a Decodable object.
    ///
    /// - Parameters:
    ///   - type: Decodable object type.
    ///   - decoder: JSONDecoder instance to use. Defaults to a new instance.
    /// - Returns: Decoded object from JSON string.
    /// - Throws: An error if any value throws an error during decoding.
    func decoded<T: Decodable>(as type: T.Type, using decoder: JSONDecoder = JSONDecoder()) throws -> T {
        guard let data = data(using: .utf8) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Failed to convert string to data using UTF8 encoding"))
        }
        return try decoder.decode(T.self, from: data)
    }
}
