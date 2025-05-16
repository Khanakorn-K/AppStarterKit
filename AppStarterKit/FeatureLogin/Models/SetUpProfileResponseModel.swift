//
//  SetUpProfileResponseModel.swift
//  AppStarterKit
//
//  Created by Chanchana on 1/4/2568 BE.
//

// MARK: - SetUpProfileResponseModel
struct SetUpProfileResponseModel: Codable {
    let result: SetUpProfileInfoResponseModel?

    enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}

// MARK: - MemberProfileSetupInfo
struct SetUpProfileInfoResponseModel: Codable {
    let message: String?
    let status: Bool

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case status = "Status"
    }
}
