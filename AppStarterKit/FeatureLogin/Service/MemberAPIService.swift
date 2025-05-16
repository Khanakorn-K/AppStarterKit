//
//  MemberAPIService.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 15/5/2568 BE.
//

import Foundation

class MemberAPIService {

    func fetchSocialLogin(_ body: SocialLoginRequestModel) async throws -> SocialLoginResponseModel {
        return try await APIEndpoint.Member.vsoc
            .asReq()
            .addBody(with: body)
            .showLog()
            .build()
    }
//
    func setUpProfile(_ body: SetUpProfileRequestModel) async throws -> SetUpProfileResponseModel {
        return try await APIEndpoint.Member.profileSetup
            .asReq()
            .addBody(with: body)
            .showLog()
            .build()
    }

    func fetchLineLogIn() async throws -> LineLoginResponseModel {
        return try await NetworkUtils.shared.getLineLogIn()
    }
    func fetchFacebookLogIn () async throws -> FacebookLoginResponseModel{
        return try await NetworkUtils.shared.getLoginFacebook()
    }
    func fetchAppleIdLogin() async throws -> AppleSignInResponseModel?{
        return try await NetworkUtils.shared.signInApple()
    }
    func signIn(_ body : LoginRequestBodyModel) async throws ->LoginResponseModel{
        return try await APIEndpoint.Member.signIn
            .asReq()
            .addBody(with: body)
            .showLog()
            .build()
    }

//
//    func fetchLoginApple() async throws -> AppleSignInResponseModel? {
//        return try await NetworkUtils.shared.signInApple()
//    }
}
