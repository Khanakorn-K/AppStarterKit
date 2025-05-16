//
//  AppleSignIn.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 24/11/2566 BE.
//

import Foundation
import AuthenticationServices

enum AppleSiginError: Error {
    case unknnown
    case error(Error)
}

class AppleSignIn: NSObject, ASAuthorizationControllerDelegate {
    
    enum Status {
        case success(ASAuthorizationAppleIDCredential)
        case fail(AppleSiginError)
    }
    
   
    
    var didCompletion: ((Status)->())?
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential
        else {
            didCompletion?(.fail(.unknnown))
            return
        }
        
        didCompletion?(.success(credential))
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        #if DEBUG
        print(error.localizedDescription)
        #endif
        
        didCompletion?(.fail(.error(error)))
    }
    
    func perform(didCompletion: ((Status)->())?) {
        self.didCompletion = didCompletion
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
}
