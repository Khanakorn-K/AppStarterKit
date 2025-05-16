//
//  SideMenuViewModel.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 20/5/2568 BE.
//
import SwiftUI
@MainActor
class SideMenuViewModel:ObservableObject{
    private let memberAPIService = MemberAPIService()
    @Published private(set) var profileInfo:ProfileInfoResponseModel?
    //MARK: Public
    public func handleGetProfile() async throws {
        try await loadProfile()
    }
    //MARK: PRIVATE
    private func loadProfile() async throws {
        let response = try await memberAPIService.fetchProfile()
        guard let result = response.result
        else {return}
        profileInfo = result
        print("profileinfo>>>>\(String(describing: profileInfo))")
    }

}
