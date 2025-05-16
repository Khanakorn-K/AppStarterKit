//
//  SideMenuContainerView.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 21/5/2568 BE.
//
import SwiftUI
import BottomSheet
@MainActor
class SideMenuContainerViewModel : ObservableObject{
    @Published var loginViewBottomSheetPosition:BottomSheetPosition = .hidden
    
    public func showLogin(){
        loginViewBottomSheetPosition = .relative(1)
    }
    public func hideLogin(){
        loginViewBottomSheetPosition = .hidden
    }
}
