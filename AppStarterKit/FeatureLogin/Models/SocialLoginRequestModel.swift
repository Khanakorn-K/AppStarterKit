//
//  SocialLoginRequestModel.swift
//  AppStarterKit
//
//  Created by Chanchana on 31/3/2568 BE.
//

struct SocialLoginRequestModel: Codable {
    let aliasName: String
    let firstName: String
    let lastName: String
    let socialid: String
    let email: String
    let dob: String
    let socopt: String
    let socialName: String
    let password: String
    let gender :String
    
    
   
    
    init(lineLoginResponseModel: LineLoginResponseModel){
        aliasName = lineLoginResponseModel.userProfile?.displayName ?? ""
        socialName = "line"
        
        firstName = ""
        lastName = ""
        socialid = lineLoginResponseModel.userProfile?.userID ?? ""
        socopt = lineLoginResponseModel.userProfile?.pictureURLLarge?.absoluteString ?? ""
        email = ""
        dob = ""
        gender = "3"
        password = .randomPassword
        
    }
    
    
    init(appleSignInResponseModel: AppleSignInResponseModel) {
        aliasName = "\(appleSignInResponseModel.firstName) \(appleSignInResponseModel.lastName)"
        socialName = appleSignInResponseModel.socialName
       
        
        firstName = appleSignInResponseModel.firstName
        lastName = appleSignInResponseModel.lastName
        socialid = appleSignInResponseModel.socialId
        socopt = appleSignInResponseModel.socialId
        email = appleSignInResponseModel.email
        dob = ""
        gender = "3"
        password = .randomPassword
    }
    
    
   
    
    init(facebookLoginResponseModel: FacebookLoginResponseModel) {
        aliasName = facebookLoginResponseModel.name
        socialName = "facebook"
        firstName = facebookLoginResponseModel.firstName
        lastName = facebookLoginResponseModel.lastName
        socialid = facebookLoginResponseModel.id
        socopt = facebookLoginResponseModel.id
        email = facebookLoginResponseModel.email
        dob = ""
        gender = "3"
        password = .randomPassword
    }
}


private extension String {
    static var randomPassword: String {
        let charactersSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var thePassword = ""
        for _ in 0 ..< 8 {
            thePassword.append(charactersSet.randomElement()!)
        }
        return thePassword
    }
}
