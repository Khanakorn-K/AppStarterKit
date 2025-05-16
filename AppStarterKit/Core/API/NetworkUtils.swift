//
//  NetworkUtils.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 3/11/2566 BE.
//

import Foundation
//import Combine
import AsyncSwiftConnect
import LineSDK
//import CombineExt
import ClientSecurityV4
import FacebookLogin
import FacebookCore
import SwifterSwift


class NetworkUtils{
    static let shared = NetworkUtils()
    
    private lazy var appleSignIn: AppleSignIn = {
        AppleSignIn()
    }()
    
    private lazy var hostConnect: HostConnect = {
        HostConnect(status: self.isSecure)
    }()
    
    private var isSecure: Bool {

        UserDefaultKey.secure.string == "true"
    }
    
    lazy var requester:Requester = {
        .init(initBaseUrl: EndPointManager.api,
              timeout: EndPointManager.timeoutInterval,
              isPreventPinning: false,
              initSessionConfig: .default,
              hasVersion: true)
    }()
    
    
    var requestBuilder:RequestBuilder{
        RequestBuilder(requester: requester)
    }
    
    func getLineLogIn() async throws -> LineLoginResponseModel {
        let linePermissions:Set<LoginPermission> = [.profile]
        return try await withCheckedThrowingContinuation {(continuation: CheckedContinuation<LineLoginResponseModel, Error>) in
            LoginManager.shared.login(permissions: linePermissions){
                switch $0 {
                case .success(let result):
                    continuation.resume(returning: .init(loginResult: result))
                    
                case .failure(let e):
                    continuation.resume(throwing: CustomError(unknowError: e.errorDescription ?? ""))
                    return
                }
            }
        }
    }
    
    func getToken() async throws -> String {
        return try await hostConnect.updateAuthenticationAsync()
    }
    
    func getTokenPublisher() async throws -> String? {
        try await hostConnect.updateAuthenticationAsync()
    }
    
    @MainActor
    func signInApple() async throws -> AppleSignInResponseModel?  {
        return try await withCheckedThrowingContinuation{ [weak self] (continuation: CheckedContinuation<AppleSignInResponseModel?, Error>) in
            self?.appleSignIn.perform(){
                switch $0 {
                case .success(let credential):
                    continuation.resume(returning: AppleSignInResponseModel(asAuthorizationAppleIDCredential: credential))
                    
                case .fail(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getLoginFacebook() async throws -> FacebookLoginResponseModel {
        
        let permissions = ["email"]
        
        return try await withCheckedThrowingContinuation{ (continuation: CheckedContinuation<FacebookLoginResponseModel, Error>) in
            FacebookLogin.LoginManager().logIn(permissions: permissions,
                                               from: nil) {  result, error in
                guard let result = result,
                      !result.isCancelled,
                      result.grantedPermissions.contains(permissions.first!) else{
                    continuation.resume(throwing: CustomError(customError: "login facebook error with \(error?.localizedDescription ?? "")"))
                    return
                }
                let parameters:[String:Any] = ["fields": "id, name, first_name, last_name, picture.type(large), email,gender"]
                GraphRequest(graphPath: "me", parameters: parameters).start(){ connection, result, error in
                    
                    guard let result = result as? [String:Any] else{
                        continuation.resume(throwing: CustomError(customError: "login facebook 'GraphRequest' error with \(error?.localizedDescription ?? "")"))
                        return
                    }
                    
                    let dataUser = FacebookLoginResponseModel(with: result)
                    
                    continuation.resume(returning: dataUser)
                }
                
                
            }
        }
    }
    
    func call<Result: Decodable>(_ url: URL?) async throws -> Result {
        guard let url = url else {
            throw URLError(.badURL,
                           userInfo: ["url": url?.absoluteString ?? "n/a"])
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse
        else { throw URLError(.cannotParseResponse) }
        
        guard (200...209).contains(httpResponse.statusCode)
        else { throw URLError(.badServerResponse,
                              userInfo: ["code": httpResponse.statusCode]) }
        
        
        return try JSONDecoder().decode(Result.self, from: data)
    }
    
    func call(_ url: URL?) async throws -> String? {
        guard let url = url else {
            throw URLError(.badURL,
                           userInfo: ["url": url?.absoluteString ?? "n/a"])
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse
        else { throw URLError(.cannotParseResponse) }
        
        guard (200...209).contains(httpResponse.statusCode)
        else { throw URLError(.badServerResponse,
                              userInfo: ["code": httpResponse.statusCode]) }
        
        return data.string(encoding: .utf8)
    }
}
