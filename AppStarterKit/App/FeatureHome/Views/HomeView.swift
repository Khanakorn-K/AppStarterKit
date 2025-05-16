//
//  HomeView.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 22/5/2568 BE.
//

import SwiftUI
struct HomeView: View {
    @State private var selectedTabIndex: Int = 0
    @State var selectedSegment: HomeSegmentOption = .nearby
    private var option: [HomeSegmentOption] = [.nearby]
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            CustomSJView(selectedTabIndex: $selectedTabIndex, header: { HomeHeaderView(selectedSegment: $selectedSegment, option: option) },
                         segmentViewControllers: [getSegments(index: 0),
                                                  getSegments(index: 1)])
            .configuration{config in
                config.headerViewOffsetHeight = 100
            }
        }
        .withDefaultNavigaitionView(title: "App Starter Kit", isShowBackButton: false)
    }

    @ViewBuilder
    private func getSegments(index: Int) -> some View {
        switch index {
        case 0:
            HomeSegmentNearByView()

        case 1:
            HomeSegmentMapView()
        default:
            EmptyView()
        }
    }
}

#Preview {
    HomeView()
}
