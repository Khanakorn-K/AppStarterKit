//
//  ForgotPasswordResponseModel.swift
//  AppStarterKit
//
//  Created by MK-Mini on 18/4/2568 BE.
//

// MARK: - ForgotPasswordResponseModel
struct ForgotPasswordResponseModel: Codable {
    let result: Bool

    enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}
