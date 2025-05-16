//
//  ForgotPasswordViewModel.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 20/5/2568 BE.
//

import SwiftUI

class ForgotPasswordViewModel: ObservableObject{
    private let memberAPISevice = MemberAPIService()
    @Published private(set) var sendEmailStatus = false
    //MARK:Public
    public func handleForgotPassword(email:String)async throws{
        try await loadForgotPassword(email: email)
    }
    //MARK:PRiVATE
    private func loadForgotPassword(email:String) async throws {
        let response = try await memberAPISevice.fetchForgotPassword(.init(email: email))
        sendEmailStatus = response.result
        print("responseloadForgotPassword >>>",response)
    }
}
