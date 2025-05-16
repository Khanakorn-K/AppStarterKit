//
//  String+.swift
//  AppStarterKit
//
//  Created by Chanchana on 28/3/2568 BE.
//

import Foundation

public extension String {
    static let emailRegax =  #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    static let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*()\\-_=+{}|:;\"'<>,.?/~`]).{8,}$"
    static let errorMsgRegaxPassword = """
    รหัสผ่านของคุณควรมี:
    • ตัวอักษรพิมพ์เล็ก อย่างน้อย 1 ตัว (a–z)
    • ตัวอักษรพิมพ์ใหญ่ อย่างน้อย 1 ตัว (A–Z)
    • ตัวเลข อย่างน้อย 1 ตัว (0–9)
    • อักขระพิเศษ อย่างน้อย 1 ตัว (เช่น !@#$%^&*)
    • ความยาวอย่างน้อย 8 ตัวอักษร
    """
    static let errorMsgRegaxEmail = "รูปแบบอีเมลไม่ถูกต้อง"
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
