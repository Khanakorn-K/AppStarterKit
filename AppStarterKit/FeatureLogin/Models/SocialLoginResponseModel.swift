//
//  SocialLoginResponseModel.swift
//  AppStarterKit
//
//  Created by Chanchana on 31/3/2568 BE.
//

struct SocialLoginResponseModel: Codable {
    let result: SocialLoginInfoResponseModel?

    enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}

// MARK: - MemberVerifyOtpInfo
struct SocialLoginInfoResponseModel: Codable, Identifiable, SetUpProfileModelProtocol {
    var id: String {
        token ?? ""
    }
    let avatar, name: String?
    let status: Bool
    let token: String?

    enum CodingKeys: String, CodingKey {
        case avatar = "Avatar"
        case name = "Name"
        case status = "Status"
        case token = "Token"
    }
}
