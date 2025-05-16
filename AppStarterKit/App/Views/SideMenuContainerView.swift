//
//  SideMEnuContainerView.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 20/5/2568 BE.
//
import BottomSheet
import struct NavigationStackBackport.NavigationStack
import SwiftUI
import SideMenu
struct SideMenuContainerView: View {
    @ObservedObject private var loginViewModel = LoginViewModel.shared
    @EnvironmentObject private var viewModel: SideMenuContainerViewModel
    @ObservedObject private var appState = AppState.shard
    @State private var isPresentedSetupProfileView = false

    @State private var isPresentedPresenPhoneOREmail = false
    @State private var isShowMenu = false
    var body: some View {
        ZStack {
            CustomSideMenu(showMenu: $isShowMenu,
                           allowGesture: $appState.isAllowGestureSideMenu,
                           mainContent: { TabbarView() },
                           sideMenuContent: { SideMenuView()})
            loginViewBottomSheet()
        }
        .fullScreenCover(isPresented: $isPresentedSetupProfileView, content: { SetupProfileView() })
        .onReceive(loginViewModel.$setUpProfileModel.dropFirst(), perform: {socialLoginResponse in
            guard let socialLoginResponse = socialLoginResponse,socialLoginResponse.status
            else{return}
            viewModel.hideLogin()
            isPresentedSetupProfileView = true
            isPresentedPresenPhoneOREmail = false
        })
        .onReceive(loginViewModel.$subsistResponse.dropFirst()){
            subsist in
            guard let subsist = subsist
            else{return}
            if subsist.isNew.negated, subsist.message == "already" {
               isPresentedPresenPhoneOREmail =  false
                viewModel.hideLogin()
            }
            else{return}

        }
        .onReceive(loginViewModel.$isLogin.dropFirst()) { isLogin in
            guard isLogin
            else { return }
            viewModel.hideLogin()
        }
        .backport.navigationDestination(isPresented: $isPresentedPresenPhoneOREmail, destination: { LoginEmailORPhoneView() })

        .onFirstAppear {
//            isShowMenu = true
        }
    }

    private func loginViewBottomSheet() -> some View {
        EmptyView()
            .bottomSheet(
                bottomSheetPosition: $viewModel.loginViewBottomSheetPosition, switchablePositions: [],
                content: { LoginView(onTapButtonEmailOROTP: {
                    isPresentedPresenPhoneOREmail = true
                })
                .padding(.bottom, safeAreaInsets().bottom)
                })
            .enableSwipeToDismiss()
            .customThreshold(0.1)
            .enableContentDrag()
            .enableTapToDismiss()
            .enableBackgroundBlur()
            .backgroundBlurMaterial(.systemDark)
            .showDragIndicator()
            .customBackground {
                Color.blue
//                    .cornerRadius(.defaultCornerRadius,corners:[.topLeft,.topRight])
            }
            .frame(width: getRect().width)
    }
}

#Preview {
    SideMenuContainerView()
}
