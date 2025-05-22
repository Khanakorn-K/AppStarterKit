//
//  FeedService.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 23/5/2568 BE.
//

class FeedService{
    func fetchPlaceList(_ body : NewsFeedPlaceRequestModel) async throws -> NewsFeedPlaceResponseModel {
        return try await APIEndpoint.Feed.getplace
            .asReq()
            .addBody(with: body)
            .showLog()
            .build()
    }
}
