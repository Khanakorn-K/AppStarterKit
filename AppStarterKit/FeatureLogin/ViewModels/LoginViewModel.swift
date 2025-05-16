//
//  LogginViewModel.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 15/5/2568 BE.
//
import SwiftUI
@MainActor
class LoginViewModel :ObservableObject{
    
    public static let shared = LoginViewModel()
    
    private let memberAPIService = MemberAPIService()
    private let clientSecurityService = ClientSecurityService()
    private var randomSocialPassword : String?
    @Published var socialLoginInfoResponseModel:SocialLoginInfoResponseModel?
    @Published  private(set) var isLogin = false
    public func handleLineLogin() async throws {
        try await loadLineLogin()
    }
    
    public  func  handleStartWithSetupProfile(avatar:UIImage?,aliasName:String?) async throws{
        if avatar != nil || aliasName != nil{
            await loadSetupProfile(avatar: avatar, aliasName:aliasName)
        }
        await  loadSetupProfile(avatar: avatar , aliasName: aliasName)
        try await handleSignInAndSaveToken()
    }
    public func handleSignInAndSaveToken() async throws{
        try await loadSignInAndSaveToken()
    }
    
    private func loadLineLogin() async throws  {
        do {
            let lineLoginResponse = try await memberAPIService.fetchLineLogIn()
            let body = SocialLoginRequestModel(lineLoginResponseModel: lineLoginResponse)
            randomSocialPassword = body.password
            guard let socialLoginResponse = try await loadSocialLogin(body) else {
                return
            }
            print(socialLoginResponse)
            self.socialLoginInfoResponseModel = socialLoginResponse
        }
    }
    private func loadFaceBookLogin() async throws{
        let fbLoginResponse = try await memberAPIService.fetchFacebookLogIn()
        let body = SocialLoginRequestModel(facebookLoginResponseModel: fbLoginResponse   )
    }
    private func loadSocialLogin(_ body :SocialLoginRequestModel) async throws ->SocialLoginInfoResponseModel?{
        do{
            let response = try await memberAPIService.fetchSocialLogin(body)
            return response.result
        }catch{
            guard let _ = error as? CustomError
            else{throw error}
            throw error
        }
    }
    private func loadSetupProfile(avatar: UIImage?, aliasName: String?) async {
        do{
            let reduceFileSizeData = await avatar?.reduceImageFileSizeAsync()
            let response = try await memberAPIService.setUpProfile(.init(aliasName: aliasName ?? "", avatar: reduceFileSizeData?.base64EncodedString() ?? ""))
            guard let result = response.result
            else{return}
            guard result.status
            else{ return}
        }catch{
            
        }
    }
    private func loadSignIn(username:String,password:String)async throws -> LoginInfoResponseModel?{
        do{
            let response = try await memberAPIService.signIn(.init(username: username, password: password))
            guard let result = response.result
            else{ return nil}
            return result
        }catch{
            throw error
        }
    }
    private func saveTokenToLocalStorage(sigInInfo:LoginInfoResponseModel,password:String) async throws{
        try clientSecurityService.setToken(signInfo: sigInInfo, password: password)
        
    }
    private func loadSignInAndSaveToken() async throws{
        guard let socialLoginInfoResponseModel = self.socialLoginInfoResponseModel
        else{return}
        guard let sigInResponse =  try await loadSignIn(username: socialLoginInfoResponseModel.name ?? "", password: socialLoginInfoResponseModel.token ?? "")
        else{ return}
        guard let randomSocialPassword = self.randomSocialPassword
        else { return  }
        try await saveTokenToLocalStorage(sigInInfo: sigInResponse, password: randomSocialPassword)
        isLogin = true
    }
}
