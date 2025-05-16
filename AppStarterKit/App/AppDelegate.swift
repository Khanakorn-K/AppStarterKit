//
//  Appdelegate.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 16/5/2568 BE.
//
import SwiftUI
import LineSDK
import FacebookCore


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        setUpSocialLogin(application, launchOptions: launchOptions)
        return true
    }

    private func setUpSocialLogin(_ application: UIApplication,
                                  launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        LoginManager.shared.setup(channelID: "1561081788", universalLinkURL: nil)
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}


