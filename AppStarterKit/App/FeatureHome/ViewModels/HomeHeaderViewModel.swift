//
//  HomeHeaderViewModel.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 22/5/2568 BE.
//
import SwiftUI
class HomeHeaderViewModel:ObservableObject{
    private let promotionService = PromotionService()
    @Published private(set) var banners : [HomeBannerModel]?
    public func handleGetBanner() async throws{
        try await loadBanner()
    }
    private func loadBanner() async throws {
        let response = try await promotionService.fetchBanner()
        guard let result = response.result  else {
            print("banner result nil")
            return
        }
        banners = result.compactMap{$0}.map{.init($0)}
    }
}
