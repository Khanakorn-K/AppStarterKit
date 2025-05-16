//
//  VerifyCodeResponseModel.swift
//  AppStarterKit
//
//  Created by MK-Mini on 16/4/2568 BE.
//

// MARK: - VerifyCodeResponseModel
struct VerifyCodeResponseModel: Codable {
    let result: VerifyCodeInfoResponseModel?

    enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}

// MARK: - MemberVerifyOtpInfo
struct VerifyCodeInfoResponseModel: Codable, SetUpProfileModelProtocol {
    let avatar, name: String?
    let status: Bool
    let token: String?
    let isNew: Bool

    enum CodingKeys: String, CodingKey {
        case avatar = "Avatar"
        case name = "Name"
        case status = "Status"
        case token = "Token"
        case isNew = "IsNew"
    }
}
