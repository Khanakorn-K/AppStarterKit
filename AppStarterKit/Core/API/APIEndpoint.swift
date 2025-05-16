//
//  APIEndpoint.swift
//  AppStarterKit
//
//  Created by Chanchana Koedtho on 3/3/2564 BE.
//  Copyright © 2564 BE megazy. All rights reserved.
//

import Foundation

protocol RouteEndpoint: RawRepresentable {
    func appendPath(path:String) -> String
}

extension RouteEndpoint {
    func appendPath(path:String) -> String{
        guard let rawValue = self.rawValue as? String
        else { return "" }
        
        return rawValue.lowercased().appending("/\(path)")
    }
}

protocol APIEndpointProtocal {
    var route: any RouteEndpoint { get }
    var path: String { get }
    var version: Float { get }
    
}

extension APIEndpointProtocal{
    var version:Float{
        return 1.0
    }
    
    func asReq()->RequestBuilder{
        NetworkUtils.shared.requestBuilder
            .addEndpoint(with: self)
    }
   
}

extension APIEndpointProtocal where Self: RawRepresentable {
    var path:String{
       
        route.appendPath(path: (rawValue as? String)?.lowercased() ?? "")
    }
}

extension APIEndpoint.Route : APIEndpointProtocal {
    var route: any RouteEndpoint {
        self
    }
    
    var path: String {
        return self.rawValue
    }
    
}

enum APIEndpoint {
    
    enum Route: String, RouteEndpoint {
        case member
        case promotion
    }
    
}


extension APIEndpoint {
    enum Member: String, APIEndpointProtocal {
        var route: any RouteEndpoint {
            Route.member
        }
        
        var version: Float {
            switch self {
            case .getProfile:
                return 5.0
            case .signIn:
                return 1.2
            default:
                return 1.0
            }
        }
        
        case signIn
        case vsoc
        case profileSetup
        case getProfile
        case subsist
        case votp
        case forgotPassword
    }
}
extension APIEndpoint{
    enum Promotion  : String,APIEndpointProtocal{
        var route: any RouteEndpoint{
            Route.promotion
        }
        var version:Float{
            switch self{
            case .getBanner:
                return 3.1
            default:
                return 1.10
            }
        }
        case getBanner
    }
}
