//
//  TabbarView.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 15/5/2568 BE.
//

import SwiftUI
struct TabbarView:View {
    @ObservedObject private var loginViewModel = LoginViewModel.shared
    @State private var isPresentedLoginView = false
    @State private var isPresentedSetupProfileView = false
    var body: some View {
        VStack{
            Button(action: {
                isPresentedLoginView = true
            }, label: {
                Text("OpenLogin")
            }
            )
            Text("Login Status:\(loginViewModel.isLogin)")
        }
        .padding()
        .sheet(isPresented: $isPresentedLoginView, content: {LoginView()})
        .fullScreenCover(isPresented: $isPresentedSetupProfileView, content:{SetupProfileView()})
        .onReceive(LoginViewModel.shared.$socialLoginInfoResponseModel.dropFirst(), perform: {socialLoginResponse in
            guard let socialLoginResponse = socialLoginResponse else { return }
            isPresentedLoginView = false
            isPresentedSetupProfileView = true}
        )
    }
}

#Preview {
    TabbarView()
}
