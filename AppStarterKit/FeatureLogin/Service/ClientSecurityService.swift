//
//  ClientSecurityService.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 16/5/2568 BE.
//
import ClientSecurityV4
class ClientSecurityService{
    private let clientAutorise = ClientAuthorize()
    func setToken(signInfo:LoginInfoResponseModel, password:String) throws{
//        clientAutorise.deleteAllKey()
        try clientAutorise.setToken(account: signInfo.userName ?? "", token: signInfo.token ?? "", expiredDate: signInfo.tokenExpire ?? "")
        try  clientAutorise.setPassword(account: signInfo.userName ?? "", password: password)
        
    }
    func getToken() async throws -> String {
        do {
            return try await NetworkUtils.shared.getToken()
        } catch {
            print("❌ getToken error in ClientSecurityService: \(error)")
            throw error
        }
    }
    func setup(){
        UserDefaultKey.tokenHost.setValue(EndPointManager.tokenHost)
#if DEBUG
        UserDefaultKey.secure.setValue("false")
#else
        UserDefaultKey.secure.setValue("true")
#endif
    }
    func clearToken(){
        clientAutorise.deleteAllKey()
    }
}
