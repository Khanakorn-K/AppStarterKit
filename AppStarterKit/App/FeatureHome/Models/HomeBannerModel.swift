//
//  HomeBannerModel.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 22/5/2568 BE.
//

import SwiftUI
import SwifterSwift
struct HomeBannerModel : Identifiable,Equatable{
    var id = UUID()
    let url : URL?
    init(_ response:BannerInfo) {
        url = response.fileName?.url
    }
}
