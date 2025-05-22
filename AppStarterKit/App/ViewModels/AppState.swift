//
//  AppState.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 22/5/2568 BE.
//

import SwiftUI
@MainActor
class AppState:ObservableObject{
    static let shard = AppState()
    @Published  var isAllowGestureSideMenu:Bool = false
    @Published  var profileInfo:ProfileInfoResponseModel?
    @Published var isShowMenuSide = false
}
