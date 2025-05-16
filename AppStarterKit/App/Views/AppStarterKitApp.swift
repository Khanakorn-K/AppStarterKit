//
//  AppStarterKitApp.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 15/5/2568 BE.
//

import SwiftUI
import struct NavigationStackBackport.NavigationStack
import LineSDK
@main
struct AppStarterKitApp: App {
    @UIApplicationDelegateAdaptor var delegate : AppDelegate
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                TabbarView()
//                LoginView()
            }
            .onOpenURL(perform: {url in _ = LoginManager.shared.application(.shared, open:  url)})
        }
    }
}
#Preview{
    NavigationStack{
        TabbarView()
    }
}
