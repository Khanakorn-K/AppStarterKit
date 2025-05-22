//
//  MapView.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 23/5/2568 BE.
//
import SwiftUI
import Kingfisher
struct MapView:View {
    var body: some View {
        ZStack(){
            MapboxUIViewRepresentable(pinContent: CustomPinView())
                .didSelectPin{
                    print($0.placeId)
                }
        }
        .withDefaultNavigaitionView(title: "Map" , isShowBackButton: false)
    }
}
struct CustomPinView: PinView {
    var didShowSubMissionUpdate: ((@escaping (Bool) -> Void) -> Void)?
    var disCateImageUpdate: ((@escaping (URL?) -> Void) -> Void)?
    var didPinImageUpdate: ((@escaping (URL?) -> Void) -> Void)?
    
    @State var pinImageURL: URL?
    @State var cateImageURL: URL?
    @State var isShowSubMission: Bool? = true
    
    var body: some View {
        ZStack(alignment: .center) {
            Image(.icBasePin)
                .resizable()
                .scaledToFit()
            
            KFImage(pinImageURL)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .offset(y: -5)
        }
        .onAppear(perform: binding)
    }
    
    private func binding() {
        didPinImageUpdate? { url in
            pinImageURL = url
        }
    }
}

#Preview {
    MapView()
}
