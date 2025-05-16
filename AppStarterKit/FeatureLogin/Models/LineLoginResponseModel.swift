//
//  LineLoginResponseModel.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 21/11/2566 BE.
//

import Foundation
import LineSDK

struct LineLoginResponseModel {
    public let accessToken: AccessToken
    /// The permissions bound to the `accessToken` object by the authorization process.
    public let permissions: Set<LoginPermission>
    /// Contains the user profile including the user ID, display name, and so on. The value exists only when the
    /// `.profile` permission is set in the authorization request.
    public let userProfile: UserProfile?
    /// Indicates that the friendship status between the user and the LINE Official Account changed during the login.
    /// This value is non-`nil` only if the `.botPromptNormal` or `.botPromptAggressive` are specified as part of the
    /// `LoginManagerOption` object when the user logs in. For more information, see "Add a LINE Official Account as
    /// a friend when logged in (bot link)" at https://developers.line.biz/en/docs/line-login/web/link-a-bot/
    public let friendshipStatusChanged: Bool?
    /// The `nonce` value when requesting ID Token during login process. Use this value as a parameter when you
    /// verify the ID Token against the LINE server. This value is `nil` if `.openID` permission is not requested.
    public let IDTokenNonce: String?
    
    
    init(loginResult: LoginResult){
        accessToken = loginResult.accessToken
        permissions = loginResult.permissions
        userProfile = loginResult.userProfile
        friendshipStatusChanged = loginResult.friendshipStatusChanged
        IDTokenNonce = loginResult.IDTokenNonce
    }
}
