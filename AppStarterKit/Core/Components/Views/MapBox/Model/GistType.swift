//
//  GistType.swift
//  AppStarterKit
//
//  Created by MK-Mini on 26/4/2568 BE.
//

import SwiftUI

enum GistType: String, UnknownCase, Codable, Equatable {
    static var unknownCase: GistType = .unknown
    
    case communityPost = "community_post"
    case guidebook = "guidebook"
    case mission = "mission"
    case quest = "quest"
    case missionStamper = "mission_stamper"
    case missionStamm = "mission_stamm"
    case unknown
    
    var title: String {
        switch self {
        case .missionStamm:
            return "ZTAMM"
        case .missionStamper:
            return "STAMPER"
            
        default:
            return ""
        }
    }
    
    var gradient: [Color] {
        switch self {
        case .missionStamm:
            return .mainGardient
        case .missionStamper:
            return .gardient2
        case .quest:
            return .gardient3
            
        default:
            return .mainGardient
        }
    }
}
