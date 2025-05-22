//
//  HomeView.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 22/5/2568 BE.
//

import SwiftUI
import Kingfisher
import NavigationStackBackport

struct HomeView: View {
    @ObservedObject private var appState = AppState.shard
    @State private var selectedTabIndex: Int = 0
    @State private var selectedSegment: HomeSegmentOption = .nearby
    @State private var isPresendtedDetail: HomeSegmentNearbyModel?
    @State private var onRefresh : ((UIRefreshControl)->())?
    private var option: [HomeSegmentOption] = [.nearby]
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            CustomSJView(selectedTabIndex: $selectedTabIndex, header: { HomeHeaderView(selectedSegment: $selectedSegment,
                                                                                       option: option) },
                         segmentViewControllers: [getSegments(index: 0)])
            .configuration{config in
                config.headerViewOffsetHeight = 44
            }
            .refresher{done in
                onRefresh?(done)
            }
        }
        .withDefaultNavigaitionView(title: "App Starter Kit", isShowBackButton: false,leftContent: {
            Group{
                if let avatar =  appState.profileInfo?.avatar?.url{
                    KFImage(avatar)
                        .resizable()
                }else{
                    Image(.icAppIcon)
                        .resizable()
                }
            }
            .scaledToFit()
            .frame(40)
            .clipShape(Circle())
            .onTapGesture {
                appState.isShowMenuSide = true
            }
        })        //นำไปอีกหน้า
        .backport.navigationDestination(item: $isPresendtedDetail, destination: {
            item in HomeNearbyDetailView(detail: item)
        })
    }
    
    @ViewBuilder
    private func getSegments(index: Int) -> some View {
        switch index {
        case 0:
            HomeSegmentNearbyView()
                .onTapNearByItem{
                    item in isPresendtedDetail = item
                }
                .onRefresh($onRefresh)
            
        default:
            EmptyView()
        }
    }
}

#Preview {
    HomeView()
}
