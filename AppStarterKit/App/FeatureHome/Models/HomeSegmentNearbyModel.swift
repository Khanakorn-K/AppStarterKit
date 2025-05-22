//
//  HomeSegmentNearbyModel.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 23/5/2568 BE.
//

import Foundation
import SwifterSwift
struct HomeSegmentNearbyModel:Identifiable,Equatable,Hashable{
    var id = UUID()
    let placeName:String
    let placeCover:URL?
    init(_ data : NewFeedPlaceInfo) {
        self.placeName = data.name ?? "-"
        self.placeCover = data.cover?.url
    }
}
