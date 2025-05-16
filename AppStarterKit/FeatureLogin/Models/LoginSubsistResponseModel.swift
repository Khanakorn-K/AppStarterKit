//
//  LoginSubsistResponseModel.swift
//  AppStarterKit
//
//  Created by MK-Mini on 16/4/2568 BE.
//

// MARK: - LoginSubsistResponseModel
struct LoginSubsistResponseModel: Codable {
    let result: LoginSubsistInfoResponseModel?

    enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}

// MARK: - MemberSubsistInfo
struct LoginSubsistInfoResponseModel: Codable {
    let isNew, isSentOtpSuccess: Bool
    let message: String?

    enum CodingKeys: String, CodingKey {
        case isNew = "IsNew"
        case isSentOtpSuccess = "IsSentOtpSuccess"
        case message = "Message"
    }
}
