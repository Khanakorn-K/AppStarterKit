// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let bannerResponseModel = try? JSONDecoder().decode(BannerResponseModel.self, from: jsonData)

import Foundation

// MARK: - BannerResponseModel
struct BannerResponseModel: Codable {
    let result: [BannerInfo?]?

    enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}

// MARK: - BannerInfo
struct BannerInfo: Codable {
    let bannerType, fileName, link: String?
    let promotionID: Int

    enum CodingKeys: String, CodingKey {
        case bannerType = "BannerType"
        case fileName = "FileName"
        case link = "Link"
        case promotionID = "PromotionID"
    }
}
