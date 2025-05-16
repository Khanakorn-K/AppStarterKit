//
//  LoginInfoResponseModel.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 21/11/2566 BE.
//

import Foundation



struct LoginInfoResponseModel: Codable {
    let isNewRegister: Bool
    let token:String?
    let tokenExpire, userName: String?

    enum CodingKeys: String, CodingKey {
        case isNewRegister = "IsNewRegister"
        case token = "Token"
        case tokenExpire = "TokenExpire"
        case userName = "UserName"
    }
}
