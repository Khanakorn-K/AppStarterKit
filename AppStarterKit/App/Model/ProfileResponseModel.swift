// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let forgotPasswordResponseModel = try? JSONDecoder().decode(ForgotPasswordResponseModel.self, from: jsonData)

import Foundation

// MARK: - ProfileResponseModel
struct ProfileResponseModel: Codable {
    let result: ProfileInfoResponseModel?

    enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}

// MARK: - ProfileInfo
struct ProfileInfoResponseModel: Codable {
    let aliasName, avatar: String?
    let coin: Int
    let dob, email, firstName: String?
    let gender, heightCM: Int
    let lastName: String?
    let level: Int
    let memberType, organization, organizImage, phone: String?
    let shortDesc, socialName: String?
    let weightKG: Int

    enum CodingKeys: String, CodingKey {
        case aliasName = "AliasName"
        case avatar = "Avatar"
        case coin = "Coin"
        case dob = "Dob"
        case email = "Email"
        case firstName = "FirstName"
        case gender = "Gender"
        case heightCM = "HeightCM"
        case lastName = "LastName"
        case level = "Level"
        case memberType = "MemberType"
        case organization = "Organization"
        case organizImage = "OrganizImage"
        case phone = "Phone"
        case shortDesc = "ShortDesc"
        case socialName = "SocialName"
        case weightKG = "WeightKG"
    }
}
