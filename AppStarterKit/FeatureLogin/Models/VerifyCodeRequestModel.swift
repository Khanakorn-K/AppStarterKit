//
//  VerifyCodeRequestModel.swift
//  AppStarterKit
//
//  Created by MK-Mini on 16/4/2568 BE.
//

struct VerifyCodeRequestModel: Codable {
    let verifyType: String
    let verifyText: String
    let verifyRef: String
    let otpRef: String
    
    
    init(verifyType: LoginSubsistType,
         verifyText: String,
         verifyRef: String,
         otpRef: String) {
        self.verifyType = verifyType.rawValue
        self.verifyText = verifyText
        self.verifyRef = verifyRef
        self.otpRef = otpRef
    }
}
