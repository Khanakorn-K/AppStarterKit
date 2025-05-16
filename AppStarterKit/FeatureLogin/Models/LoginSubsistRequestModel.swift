//
//  LoginSubsistRequestModel.swift
//  AppStarterKit
//
//  Created by MK-Mini on 16/4/2568 BE.
//

public enum LoginSubsistType:String{
    case phone
    case mail
}

struct LoginSubsistRequestModel: Codable {
    
    let subsistType: String
    let subsistText: String
    let subsistOptText: String
    
    init(subsistType: LoginSubsistType, subsistText: String, subsistOptText: String) {
        self.subsistType = subsistType.rawValue
        self.subsistText = subsistText
        self.subsistOptText = subsistOptText
    }
}
