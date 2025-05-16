//
//  SideMenuView.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 20/5/2568 BE.
//
import SwiftUI
import Kingfisher
struct SideMenuView: View {
    @EnvironmentObject private var  sideMenuContainerViewModel:SideMenuContainerViewModel
    @StateObject private var viewModel = SideMenuViewModel()
    @ObservedObject private var loginViewModel = LoginViewModel.shared
    @State private var isPresentedAlertLogout = false
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.colorWhite.ignoresSafeArea()
            VStack(spacing: .defaultSpacing4){
                VStack(alignment: .leading, spacing: 0) {
                    imageProfileView()
                    Spacer()
                        .frame(height: 60)
                    menuView()
                }
                .padding(.horizontal, .defaultSpacing4)
                Divider()
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .confirmationDialog("ออกจากระบบ",
                            isPresented: $isPresentedAlertLogout,
                            titleVisibility: .visible,
                            actions: {
            Button("ตกลง",role: .destructive){
                Task{
                    try await loginViewModel.handleLogout()
                }
            }
            Button("ยกเลิก",role: .cancel){
                
            }
        }
        )
        .onReceive(loginViewModel.$isLogin) { isLogin in
            guard isLogin else { return }
            Task {
                print("call profile")
                try? await viewModel.handleGetProfile()
            }
        }

    }
    private func imageProfileView() -> some View {
        VStack(alignment: .leading, spacing: .defaultSpacing2) {
            ZStack(){
                if let avatar = viewModel.profileInfo?.avatar , loginViewModel.isLogin
                {
                    KFImage(avatar.url)
                        .resizable()
                        .scaledToFill()
                }
                else{
                    Image(.icProfile)
                        .resizable()
                }
            }
            .clipShape(Circle())
            .frame(80)
            aliasView()
        }
    }
    @ViewBuilder
    private func aliasView() -> some View {
        if let aliasName = viewModel.profileInfo?.aliasName,loginViewModel.isLogin{
            Text(aliasName)
                .largeTitleFont()
                .colorTitle()
        }
        else{
            Text("กรุณาเข้าสู่ระบบ")
                .largeTitleFont()
                .colorTitle()
        }
    }
    
    private func menuView() -> some View {
        VStack(alignment: .leading, spacing: .defaultSpacing2) {
            menuItemView(image: .icInbox, title: "ข้อความถึงคุณ"){
                print("inbox")
            }
            menuItemView(image: .icSetting, title: "ตั้งค่า"){
                print("setting")
                
            }
            menuLocalizedView(){
                print("ภาษา")
            }
            menuItemView(image: .icSignOut, title: loginViewModel.isLogin ? "ออกจากระบบ" : "เข้าสู่ระบบ"){
                guard loginViewModel.isLogin
                else {
                    sideMenuContainerViewModel.showLogin()
                    return
                }
                isPresentedAlertLogout = true
            }
            Divider()
        }
    }
    
    private func menuItemView(image: ImageResource, title: String, action: (() -> Void)? = nil) -> some View
    {
        Button(action: { action?() },
               label: {
            HStack(spacing: .defaultSpacing2) {
                Image(image)
                    .resizable()
                    .frame(.defaultButtonIcon * 1.5)
                Text(title)
                    .bodyFont()
                    .colorTitle()
                
            }
            .frame(maxWidth: .infinity,alignment: .leading)
        }
        )
        .contentShape(Rectangle())
    }
    private func menuLocalizedView(action:(()->())?=nil)->some View {
        Button(action: { action?() },
               label: {
            HStack(spacing: .defaultSpacing2) {
                Image(.icLocalized)
                    .resizable()
                    .frame(.defaultButtonIcon * 1.5)
                Text("ภาษา")
                    .bodyFont()
                    .colorTitle()
                Spacer()
                HStack(spacing: .defaultSpacing2){
                    Text("ไทย")
                        .bodyFont()
                        .colorTitle()
                    Image(.icThaiFlag)
                }
            }
            .frame(maxWidth: .infinity,alignment: .leading)
        }
        )

        .contentShape(Rectangle())
    }
}

#Preview {
    SideMenuView()
}
