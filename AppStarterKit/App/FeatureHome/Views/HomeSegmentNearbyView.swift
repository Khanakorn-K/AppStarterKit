//
//  HomeSegmentNearByView.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 22/5/2568 BE.
//
import SwiftUI
import Kingfisher
import SwifterSwift
import NavigationStackBackport
struct HomeSegmentNearbyView:View {
    @StateObject private var viewModel = HomeSegmentNearbyViewModel()
    @State private var isLoading = false
    @State private var isPresendtedDetail: HomeSegmentNearbyModel?
    @Binding var onRefresh:((UIRefreshControl)->())?
    var onTap : ((HomeSegmentNearbyModel)->())?
    init(){
        _onRefresh = .constant(nil)
    }
    var body: some View {
        ScrollView(){
            LazyVStack(spacing: .defaultSpacing4){
                ForEach(viewModel.nearbyList){
                    item in nearbyItemView(item)
                        .onAppear{
                            Task{
                                isLoading = true
                                try await                             viewModel.handleLoadNextPage(lastItem: item)
                                isLoading = false
                            }
                        }
                }
                if isLoading {
                 ProgressView()
                }
            }
            .padding(.defaultSpacing2)
        }
        .refreshable {
            Task{
                try await viewModel.handleRefresh()
            }
        }
        .onFirstAppear{
            Task{
                try await viewModel.handleOnAppear()
                print("data>>>>>",viewModel.nearbyList)
            }
        }
        .onAppear{
            onRefresh = { done in
                Task{
                    try? await viewModel.handleRefresh()
                    done.endRefreshing()
                }
            }
        }

    }
    
    private func nearbyItemView(_ item:HomeSegmentNearbyModel)->some View {
        GeometryReader{proxy in
            ZStack{
                HStack(alignment: .top ,spacing: .defaultSpacing2){
                    KFImage(item.placeCover)
                        .resizable()
                        .scaledToFill()
                        .frame(proxy.size.height)
                        .clipped()
                    VStack(alignment: .leading,spacing: 0){
                        Text(item.placeName)
                            .lineLimit(1)
                            .bodyFont()
                            .colorTitle()
                        Divider() // เส้นเหมือน <hr/>
                    }
                    .padding(.vertical,.defaultSpacing2)
                }
            }
            .frame(maxWidth:.infinity,alignment: .leading)
            .background(Color.white)
            .cornerRadius(.defaultCornerRadius)
            .defaultShadow(.defaultShadow)
            
        }
        .frame(height: 100)
        .onTapGesture {
            onTap?(item)
        }
        .contentShape(Rectangle())
    }
}
#Preview {
    HomeSegmentNearbyView()
}
extension HomeSegmentNearbyView:Buildable{
    func onTapNearByItem(_ value:((HomeSegmentNearbyModel)->())?) -> Self {
        mutating(keyPath:\.onTap , value: value)
    }
    func onRefresh(_ value : Binding<((UIRefreshControl)->())?>) ->Self{
        binding(\._onRefresh,to:value )
    }
}
