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
        try clientAutorise.setToken(account: signInfo.userName ?? "", token: signInfo.token ?? "", expiredDate: signInfo.tokenExpire ?? "")
        try  clientAutorise.setPassword(account: signInfo.userName ?? "", password: password)
        func getToken() async throws -> String{
            return try await NetworkUtils.shared.getToken()
        }
    }
}
