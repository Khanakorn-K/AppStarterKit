//
//  PromotionService.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 22/5/2568 BE.
//
class PromotionService{
    func fetchBanner() async throws -> BannerResponseModel {
        return try await  APIEndpoint.Promotion.getBanner
            .asReq()
            .showLog()
            .build()
    }
}
