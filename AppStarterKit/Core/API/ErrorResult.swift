//
//  APIErrorResult.swift
//  AppStarterKit
//
//  Created by Chanchana Koedtho on 27/7/2564 BE.
//

import Foundation


// MARK: - ErrorResult
struct ErrorResult: Codable {
    let message, exceptionMessage, exceptionType, stackTrace: String

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case exceptionMessage = "ExceptionMessage"
        case exceptionType = "ExceptionType"
        case stackTrace = "StackTrace"
    }
}
