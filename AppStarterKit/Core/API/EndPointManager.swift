//
//  EndpointManager.swift
//  AppStarterKit
//
//  Created by MAC-KHUAD on 3/9/2563 BE.
//  Copyright © 2563 megazy. All rights reserved.
//

import Foundation


struct EndPointManager {
    

    static let timeoutInterval = 30
    
    static let mockUserData: LoginRequestBodyModel = .init(username: "mezfortest@gmail.com",
                                                           password: "!1Qazxsw2")
//    
//        static let mockUserData: LoginRequestBodyModel = .init(username: "tripper-0543659917",
//                                                           password: "3189RBmpt")
    
    static var tokenHost: String{
        return ""//"\(EndPointManager.api)/v\(APIEndpoint.Member.signin.version)/\(APIEndpoint.Member.signin.path)"
    }

    static var isDev:Bool{
        selectMode == .test
    }
    
    static public var api:String{
        selectMode.api
    }
    
    static public var socket:String{
        selectMode.socket
    }
    
    static public var map:String{
        selectMode.map
    }
    
    static public var payment:String{
        selectMode.payment
    }
    
    
    static public var web:String{
        selectMode.web
    }
    
    static public var search:String{
        return selectMode.search
    }
    
    static public var searchContent:String{
        return selectMode.searchContent
    }
    
    static public var redirectStrava:String{
        return selectMode.redirectStrava
    }
    
    static public var googleMapPlaceAPI: String {
        return selectMode.googleMapPlaceAPI
    }
    
    static public var selectMode:EndPointType{
        #if DEBUG
      
        return .test
//        return .production()
        #else
        return .production()
        #endif
    }
    
    
    
}

enum EndPointType:Equatable {
    case test
    case production(_ ver:Int = 5)
    
    
    var host:String{
        switch self {
        case .production(_):  return "https://apr.jertam.com/"
        case .test : return "https://dvapr.jertam.com/"
        }
    }
    
    var api:String{
        return "\(host)api"
    }
    
    
    var socket:String{
        switch self {
        case .production(_) : return "https://sig.jertam.com/chatHub"
        case .test : return "https://dvsig.jertam.com/chatHub"

        }
    }
    
    var map:String{
        switch self {
        case .production(_) : return "https://location.jertam.com/geoserver/jertammap"
        case .test : return "https://location.jertam.com/geoserver/devjertammap"

        }
    }
    
    var payment:String{
        switch self {
        case .production(_) : return "https://apr.jertam.com/"
        case .test : return "https://dvapr.jertam.com/"
        }
    }
    
    
    var web:String{
        switch self {
        case .production(_):
            return "https://www.jertam.com/"
        
        case .test:
            return "https://dv.jertam.com/"
        }
    }
    
    
    var search:String{
        switch self {
        case .production(_) : return "https://find.megazy.com/JTTransportQueryAPI/jttransport"
        case .test : return "https://find.megazy.com/JTTransportQueryAPI/jttransport"

        }
    }
    
    var searchContent:String{
        return "https://find.megazy.com/JTContentQueryAPI/jtcontent"
    }
    
    var redirectStrava:String{
        return "\(host)r/stravadp"
    }
    
    var googleMapPlaceAPI: String {
        return "https://maps.googleapis.com/maps/api/place"
    }
}
