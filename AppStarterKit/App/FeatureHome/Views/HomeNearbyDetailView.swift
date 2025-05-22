//
//  HomeNearbyDetailView.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 23/5/2568 BE.
//

import SwiftUI
import Kingfisher
struct HomeNearbyDetailView:View {
    let detail : HomeSegmentNearbyModel?
    var body: some View {
        ZStack{
            ScrollView{
                VStack(alignment: .leading,spacing: .defaultSpacing4,){
                    KFImage(detail?.placeCover)
                        .resizable()
                        .scaledToFit()
                    VStack(){
                        Text(detail?.placeName ?? "")
                            .padding(.horizontal,.defaultSpacing2)
                    }
                }
            }
        }
        .withDefaultNavigaitionView(title: detail?.placeName ?? "")
    }
}
#Preview {
    HomeNearbyDetailView(detail: nil)
}
