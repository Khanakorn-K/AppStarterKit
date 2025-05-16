//
//  UnknownCase.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 17/11/2566 BE.
//

import Foundation

protocol UnknownCase: RawRepresentable, CaseIterable where RawValue: Equatable & Codable {
    static var unknownCase: Self { get }
}

extension UnknownCase {
    public init(rawValue: RawValue) {
        let value = Self.allCases.first { $0.rawValue == rawValue }
        self = value ?? Self.unknownCase
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(RawValue.self)
        let value = Self(rawValue: rawValue)
        self = value ?? Self.unknownCase
    }
}
