//
//  HomeHeaderView.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 22/5/2568 BE.
//

import SwiftUI
import SwiftUIPager
import SwifterSwift
import Kingfisher
enum HomeSegmentOption:SegmentControlItemProtocol,CaseIterable{
    var id: Self {self}
    case nearby
    var title:String{
        switch self{
        case .nearby:
            return "สถานที่ใกล้เคียง"
        }
    }
}
struct HomeHeaderView:View {
    @Binding var selectedSegment:HomeSegmentOption
    @StateObject private var viewModel = HomeHeaderViewModel()
    @StateObject private var page = Page.first()
    @ObservedObject private var appState = AppState.shard
    let option : [HomeSegmentOption]
    let bannerMock = [Color.red,.green,.blue,.orange]
    let bannerRatio = 1280.0 / 720.0
    var body: some View {
            ZStack(){
                Color.green.ignoresSafeArea()
                VStack(){
                    bannerView()
                    segmentView()
                     
                }
                .onFirstAppear {
                    Task{
                        try await viewModel.handleGetBanner()
                    }
                }
            }
        
    }
    
    private func bannerView()->some View {
        ZStack(){
            let padding :CGFloat = 20
            let width : CGFloat = getRect().width - (padding * bannerMock.count.cgFloat - 1)
            Pager(page: page,
                  data: viewModel.banners ?? [],
                  content: {item in
                bannerItemView(item)
            })
            .itemSpacing(.defaultSpacing2)
            .pagingPriority(.simultaneous)
            .onDraggingChanged{ offset in
                if page.index == 0 {
                    appState.isAllowGestureSideMenu = true
                }else{
                    appState.isAllowGestureSideMenu = false
                }
            }
//            .onDraggingEnded{
//                guard  page.index == 0
//                else{return}
//                
//            }
            .preferredItemSize(.init(width: width, height: width / bannerRatio))
            .frame(height: width/bannerRatio)
       }
    }
    private func bannerItemView(_ item:HomeBannerModel)->some View{
        KFImage(item.url)
            .resizable()
            .scaledToFill()
    }
    private func segmentView()->some View{
        CustomSegmentControl(selectedSegment: $selectedSegment, options: option, customText: {_,_ in
            return nil})
    }
    
}

