//
//  LogginViewModel.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 15/5/2568 BE.
//
import SwiftUI
@MainActor
class LoginViewModel: ObservableObject {
    public static let shared = LoginViewModel()

    private let memberAPIService = MemberAPIService()
    private let clientSecurityService = ClientSecurityService()
    @Published var setUpProfileModel: SetUpProfileModelProtocol?

    @Published private(set) var isLogin = false {
        didSet {
            UserDefaultKey.isLogin.setValue(isLogin)
        }
    }

    @Published private(set) var isLoadingSubsis = false
    @Published private(set) var isLoadingVerifyOPT = false
    @Published private(set) var isValidOPT = false

    @Published private(set) var subsistResponse: LoginSubsistInfoResponseModel?
    @Published private(set) var loginSubsistType: LoginSubsistType?
    @Published private(set) var subsistTextPhoneOREmail: String?
    private init() {
        if UserDefaultKey.isLogin.bool.negated {
            clientSecurityService.clearToken()
        } else {
            isLogin = true
        }
    }

    // MARK: Public

    // func for call
    public func handleLineLogin() async throws {
        try await loadLineLogin()
    }

    public func handleFacebookLogin() async throws {
        try await loadFaceBookLogin()
    }

    public func handleAppleLogin() async throws {
        try await loadAppleLogin()
    }

    public func handleStartWithSetupProfile(avatar: UIImage?, aliasName: String?) async throws {
        if avatar != nil || aliasName != nil {
            await loadSetupProfile(avatar: avatar, aliasName: aliasName)
        }
    }

    public func handleSigninAndSaveTokenWhenAlreadyEmail(email: String, password: String) async throws {
        
    }

    public func handleSubsist(type: LoginSubsistType, phoneOrEmail: String, password: String = "") async throws {
        isLoadingSubsis = true
        loginSubsistType = type
        subsistTextPhoneOREmail = phoneOrEmail
        do { guard let response = try await loadSubsist(type: type, phoneOrEmail: phoneOrEmail, password: password)
            else { return }
            subsistResponse = response
        } catch {
            isLoadingSubsis = false
            throw error
        }
    }

    public func handleVerifyOTP(type: LoginSubsistType, opt: String, phoneOrEmail: String, otpRef: String) async throws {
        isLoadingVerifyOPT = false
        do {
            guard let response = try await loadVerifyOTP(type: type, otp: opt, phoneOrEmail: phoneOrEmail, otpref: otpRef)
            else { return }
            isLoadingVerifyOPT = false
            isValidOPT = response.status
            setUpProfileModel = response

        } catch {
            isLoadingVerifyOPT = false
        }
    }

    public func handleLogout() async throws {
        clientSecurityService.clearToken()
        isLogin = false
    }

    // MARK: Private

    // Line
    private func loadLineLogin() async throws {
        do {
            let lineLoginResponse = try await memberAPIService.fetchLineLogIn()
            let body = SocialLoginRequestModel(lineLoginResponseModel: lineLoginResponse)
            guard let socialLoginResponse = try await loadSocialLogin(body) else {
                return
            }
            print("socialLoginResponse", socialLoginResponse)
            try await validateSetupProfileForNewRegister(socialLoginResponse)
        }
    }

    // apple
    private func loadAppleLogin() async throws {
        guard let appleSignInResponse = try await memberAPIService.fetchAppleIdLogin() else { return
        }

        let body = SocialLoginRequestModel(appleSignInResponseModel: appleSignInResponse)
        guard let socialLoginResponse = try await loadSocialLogin(body) else {
            return
        }

        print("✅ Apple login success: \(socialLoginResponse)")
        try await validateSetupProfileForNewRegister(socialLoginResponse)
    }

    private func validateSetupProfileForNewRegister(_ socialLoginResponse: SocialLoginInfoResponseModel) async throws {
        guard let signInResponse = try await loadSignInAndSaveToken(socialLoginResponse)
        else { return }
        guard signInResponse.isNewRegister
        else {
            return
        }
        self.setUpProfileModel = socialLoginResponse
    }

    private func loadFaceBookLogin() async throws {
        let fbLoginResponse = try await memberAPIService.fetchFacebookLogIn()
        let body = SocialLoginRequestModel(facebookLoginResponseModel: fbLoginResponse)
        guard let socialLoginResponse = try await loadSocialLogin(body)
        else { return }
        print("Facebook login success", socialLoginResponse)
        try await validateSetupProfileForNewRegister(socialLoginResponse)
    }

    private func loadSocialLogin(_ body: SocialLoginRequestModel) async throws -> SocialLoginInfoResponseModel? {
        do {
            let response = try await memberAPIService.fetchSocialLogin(body)
            return response.result
        } catch {
            guard let _ = error as? CustomError
            else { throw error }
            throw error
        }
    }

    private func loadSetupProfile(avatar: UIImage?, aliasName: String?) async {
        do {
            let reduceFileSizeData = await avatar?.reduceImageFileSizeAsync()
            let response = try await memberAPIService.setUpProfile(.init(aliasName: aliasName ?? "", avatar: reduceFileSizeData?.base64EncodedString() ?? ""))
            guard let result = response.result
            else { return }
            guard result.status
            else { return }
        } catch {
        }
    }

    private func loadSignIn(username: String, password: String) async throws -> LoginInfoResponseModel? {
        do {
            let response = try await memberAPIService.signIn(.init(username: username, password: password))
            guard let result = response.result
            else { return nil }
            return result
        } catch {
            throw error
        }
    }

    private func saveTokenToLocalStorage(sigInInfo: LoginInfoResponseModel, password: String) throws {
        do {
            try clientSecurityService.setToken(signInfo: sigInInfo, password: password)

        } catch {
            print("saveTokenToLocalStorage", error)
            throw error
        }
    }

    private func loadSignInAndSaveToken(_ socialLoginResponseModel: SocialLoginInfoResponseModel) async throws -> LoginInfoResponseModel? {
        let socialLoginInfoResponseModel = self.setUpProfileModel
        let username = socialLoginInfoResponseModel?.name ?? socialLoginResponseModel.name ?? ""
        let password = socialLoginInfoResponseModel?.token ?? socialLoginResponseModel.token ?? ""
        print(socialLoginInfoResponseModel)
        guard let sigInResponse = try await loadSignIn(username: username,
                                                       password: password)
        else { return nil }
        try? saveTokenToLocalStorage(sigInInfo: sigInResponse,
                                    password: password)
        isLogin = true
        return sigInResponse
    }

    private func loadSubsist(type: LoginSubsistType, phoneOrEmail: String, password: String = "") async throws -> LoginSubsistInfoResponseModel? {
        let subSisResponse = try await memberAPIService.fetchSubsist(.init(subsistType: type, subsistText: phoneOrEmail, subsistOptText: password))
        guard let result = subSisResponse.result else { return nil }
        return result
    }

    private func loadVerifyOTP(type: LoginSubsistType, otp: String, phoneOrEmail: String, otpref: String) async throws -> VerifyCodeInfoResponseModel? {
        let verifyOTP = try await memberAPIService.fetchVerifyOTP(.init(verifyType: type, verifyText: otp, verifyRef: phoneOrEmail, otpRef: otpref))
        guard let result = verifyOTP.result
        else { return nil }
        return result
    }
    private func loadSignInAndSaveTokenWhenAlreadyEmail(email:String,password:String) async throws{
        guard let signInResponse = try await loadSignIn(username: email, password: password) else { return  }
        try saveTokenToLocalStorage(sigInInfo: signInResponse, password: password)
        isLogin = true
    }
}
