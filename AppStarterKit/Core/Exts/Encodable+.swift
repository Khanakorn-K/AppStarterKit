//
//  Encodable+.swift
//  AppStarterKit
//
//  Created by Chanchana on 28/3/2568 BE.
//

import Foundation

public extension Encodable {
    /// SwifterSwift: Encode into JSON data.
    func toJSON(outputFormatting: JSONEncoder.OutputFormatting = []) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = outputFormatting
        return try encoder.encode(self)
    }
    
    /// SwifterSwift: Encode into JSON string.
    func jsonString(outputFormatting: JSONEncoder.OutputFormatting = []) throws -> String? {
        let data = try toJSON(outputFormatting: outputFormatting)
        return String(data: data, encoding: .utf8)
    }
}
