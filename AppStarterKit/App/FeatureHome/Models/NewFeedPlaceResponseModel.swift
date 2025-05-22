// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newsFeedPlaceResponseModel = try? JSONDecoder().decode(NewsFeedPlaceResponseModel.self, from: jsonData)

import Foundation

// MARK: - NewsFeedPlaceResponseModel
struct NewsFeedPlaceResponseModel: Codable {
    let result: [NewFeedPlaceInfo?]?

    enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}

// MARK: - NewFeedPlaceInfo
struct NewFeedPlaceInfo: Codable {
    let cover: String?
    let discover: MemberShortInfo?
    let keepAlready: Bool
    let keepCount: Int
    let name: String?
    let placeID: Int
    let placeType: String?
    let reactionCount: Int
    let reactionScoreAlready: Bool

    enum CodingKeys: String, CodingKey {
        case cover = "Cover"
        case discover = "Discover"
        case keepAlready = "KeepAlready"
        case keepCount = "KeepCount"
        case name = "Name"
        case placeID = "PlaceID"
        case placeType = "PlaceType"
        case reactionCount = "ReactionCount"
        case reactionScoreAlready = "ReactionScoreAlready"
    }
}

// MARK: - MemberShortInfo
struct MemberShortInfo: Codable {
    let aliasName, avatar: String?
    let id: Int
    let memberIdentify: String?

    enum CodingKeys: String, CodingKey {
        case aliasName = "AliasName"
        case avatar = "Avatar"
        case id = "Id"
        case memberIdentify = "MemberIdentify"
    }
}
