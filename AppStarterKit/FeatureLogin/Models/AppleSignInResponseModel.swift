//
//  AppleSignInResponseModel.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 24/11/2566 BE.
//

import Foundation
import AuthenticationServices

struct AppleSignInResponseModel {
    let firstName: String
    let lastName: String
    let email: String
    let socialId: String
    let socialName = "APPLE"
    
    init(asAuthorizationAppleIDCredential: ASAuthorizationAppleIDCredential){
        firstName = asAuthorizationAppleIDCredential.fullName?.givenName ?? ""
        lastName = asAuthorizationAppleIDCredential.fullName?.familyName ?? ""
        email = asAuthorizationAppleIDCredential.email ?? ""
        socialId = asAuthorizationAppleIDCredential.user
    }
}
