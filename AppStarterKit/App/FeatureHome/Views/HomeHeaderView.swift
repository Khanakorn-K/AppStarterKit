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
    @State private var timer : Timer?
    @State private var isDraging = false
    let option : [HomeSegmentOption]
    let bannerMock = [Color.red,.green,.blue,.orange]
    let bannerRatio = 1280.0 / 720.0
    private let limiter = Limiter(policy: .debounce, duration: 1)
    var body: some View {
            ZStack(){
                VStack(){
                    bannerView()
                    segmentView()
                     
                }
                .onFirstAppear {
                    Task{
                        try await viewModel.handleGetBanner()
                        startTimer()
                    }
                }
            }
        
    }
    
    private func bannerView()->some View {
        ZStack(){
            let padding :CGFloat = .defaultSpacing4
            let width : CGFloat = getRect().width - (padding * ((viewModel.banners?.count ?? 0).cgFloat - 1))
            Pager(page: page,
                  data: viewModel.banners ?? [],
                  content: {item in
                bannerItemView(item)
            })
            .itemSpacing(.defaultSpacing2)
            .bounces(false)
            .preferredItemSize(.init(width: width, height: width / bannerRatio))
            .pagingPriority(.simultaneous)
            .onDraggingBegan{
                appState.isAllowGestureSideMenu = false
            }
            .onDraggingChanged{ offset in
                if !isDraging{
                    isDraging = true
              }
                if page.index == 0, !appState.isAllowGestureSideMenu,offset < 0 {
                    appState.isAllowGestureSideMenu = true
                }
            }

            .onDraggingEnded{
                isDraging = false
                Task{
                    await limiter.submit{
                        isDraging = false
                    }
                }
            }
            .frame(height: width/bannerRatio)
            .onChange(of: isDraging){
                if $0 {
                    
                    timer?.invalidate()
                }
                else{
                    startTimer()
//                    appState.isAllowGestureSideMenu = true

                }
            }
       }
    }
    private func bannerItemView(_ item:HomeBannerModel)->some View{
        KFImage(item.url)
            .resizable()
            .scaledToFill()
            .cornerRadius(.defaultCornerRadius)
    }
    private func segmentView()->some View{
        CustomSegmentControl(selectedSegment: $selectedSegment, options: option, customText: {_,_ in
            return nil})
    }
    private func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {
            _ in moveToNextBanner()
        }
        )
    }
    private func moveToNextBanner(){
        let bannerCount:Int = viewModel.banners?.count ?? 0
        guard  bannerCount > 0 else { return }
        withAnimation{
            if page.index == bannerCount - 1{
                page.update(.moveToFirst)
            }
            else{
                page.update(.next)
            }
        }
    }
    private func resetTimer(){
        timer?.invalidate()
        startTimer()
    }
}

