//
//  TabbarView.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 15/5/2568 BE.
//

import SwiftUI
import BottomSheet
import NavigationStackBackport
import struct NavigationStackBackport.NavigationStack
struct TabbarView:View {
    @EnvironmentObject private var viewModel:TabbarViewModel
    @EnvironmentObject private var sideMenuContainerViewModel:SideMenuContainerViewModel
    @ObservedObject private var loginViewModel = LoginViewModel.shared

    @State private var selection = 0
    init(){
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        ZStack{
            VStack(){
                TabView(selection: $selection){
                    HomeView()
                    .tag(0)
                    MapView()
                        .tag(1)
                    //                    Text("localtion")
                    //                        .tag(3)
                }
                tabbarContainerView()
            }
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity)

    }
 
    private func tabbarContainerView()->some View {
        VStack(spacing: 0){
            Divider()
            HStack(spacing: 0){
                tabbarView(index: 0, image: .icTabHome, title: "หน้าหลัก")
                tabbarView(index: 1, image: .icTabMap, title: "แผนที่")
            }
            .padding(.top,.defaultSpacing2)
            .background(Color.black.opacity(0.03 ))
        }
    }
    private func tabbarView(index: Int, image: ImageResource, title: String, badge: Int? = nil) -> some View {
        CustomTabButton(
            isSelected: .init(
                get: { selection == index },
                set: { isSelected in
                    guard isSelected else { return }
                    selection = index
                }
            ),
            image: image,
            text: title,
            badgeCount: badge,
            isMainColorOnSelect: false
        )
    }
    
}

#Preview {
    NavigationStack{
        TabbarView()
            .environmentObject(TabbarViewModel())
    }
}
