//
//  AppStarterKitApp.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 15/5/2568 BE.
//

import SwiftUI
import struct NavigationStackBackport.NavigationStack
import LineSDK
import FacebookCore

@main
struct AppStarterKitApp: App {
    @StateObject private var tabbarViewModel = TabbarViewModel()
    @StateObject private var sideMenuContainerViewModel = SideMenuContainerViewModel()
    @StateObject private var appState = AppState.shard
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                SideMenuContainerView()
                    .environmentObject(tabbarViewModel)
                    .environmentObject(sideMenuContainerViewModel)
            }
            .onOpenURL { url in
                _ = LoginManager.shared.application(UIApplication.shared, open: url)
                ApplicationDelegate.shared.application(
                    UIApplication.shared,
                    open: url,
                    sourceApplication: nil,
                    annotation: [UIApplication.OpenURLOptionsKey.annotation]
                )
                
            }
            .preferredColorScheme(.light)
        }
    }
}

#Preview {
    NavigationStack {
        SideMenuContainerView()
            .environmentObject(TabbarViewModel())
            .environmentObject(SideMenuContainerViewModel())
            .preferredColorScheme(.light)
            .onOpenURL { url in
                _ = LoginManager.shared.application(UIApplication.shared, open: url)
                ApplicationDelegate.shared.application(
                    UIApplication.shared,
                    open: url,
                    sourceApplication: nil,
                    annotation: [UIApplication.OpenURLOptionsKey.annotation]
                )
                
            }
        
    }
}
