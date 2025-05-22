//
//  PinCircleAnimationView.swift
//  JERTAM
//
//  Created by Chanchana on 26/7/2567 BE.
//

import Foundation
import SwiftUI
import Kingfisher
import ActivityIndicatorView

struct PinCircleAnimationView: View {
    @State private var activeIndex = 0
    @State private var isScaleUp = false
    @State private var isVisible = false
    
    let dotCount = 30 // Number of dots around the circle
    let animationDuration = 0.1
    
    let urlImage: URL?
    let size: CGFloat
    
    init(urlImage: URL?, size: CGFloat = 40) {
        self.urlImage = urlImage
        self.size = size
    }
    
    var body: some View {
//        let padding: CGFloat = size * .defaultSpacing3 / 300
        let padding: CGFloat = size * .defaultSpacing2 / 300
        let radius = (size - padding) / 2
        let dotRadius: CGFloat = size * 7 / 300
        let growingPadding: CGFloat = size * (50 * (isScaleUp ? 1.5: 0.5)) / 300
        let growingPadding2: CGFloat = size * (100 * (isScaleUp ? 1.5: 0.5 )) / 300
        let lineWidth: CGFloat = size * 10 / 300
        
        ZStack {
            Circle()
                .fill(.white)
            
            KFImage(urlImage)
                .resizable()
                .setProcessor(DownsamplingImageProcessor(size: .init(width: size, height: size)))
                .scaledToFill()
                .clipShape(Circle())
                .padding(padding * 2)
            
//            ForEach(0..<dotCount, id: \.self) { index in
//                Circle()
////                    .fill(self.activeIndex >= index ? Color.yellow : Asset.Color.colorMain.swiftUIColor)
//                    .fill(self.activeIndex == 0 ? Color.yellow : Asset.Color.colorMain.swiftUIColor)
//                    .frame(width: dotRadius * 2, height: dotRadius * 2)
//                    .offset(x: radius * cos(angle(for: index)),
//                            y: radius * sin(angle(for: index)))
//                    .animation(.easeInOut(duration: self.animationDuration), value: activeIndex)
//            }
            ActivityIndicatorView(isVisible: $isVisible, type: .gradient([.white, .yellow], lineWidth: lineWidth))
                .padding(padding)
        }
        
        .frame(size)
        .background {
            GeometryReader { proxy in
                Circle()
                    .fill(Color.yellow.opacity(0.1))
                    .offset(x: -growingPadding2 / 2,
                            y: -growingPadding2 / 2)
                    .frame(width: proxy.size.width + growingPadding2,
                           height: proxy.size.height + growingPadding2 )
                    .animation(.easeInOut(duration: 1), value: isScaleUp)
            }
        }
        .background {
            GeometryReader { proxy in
                Circle()
                    .fill(Color.yellow.opacity(0.05))
                    .offset(x: -growingPadding / 2,
                            y: -growingPadding / 2)
                    .frame(width: proxy.size.width + growingPadding,
                           height: proxy.size.height + growingPadding )
                    .animation(.easeInOut(duration: 0.5), value: isScaleUp)
            }
        }
        
        .onAppear {
            startAnimation()
            isVisible = true
        }
        .onDisappear {
            isVisible = false
        }
    }
    
    private func angle(for index: Int) -> CGFloat {
        let angle = 2 * .pi / CGFloat(dotCount) * CGFloat(index)
        return angle - .pi / 2 // Adjust to start at the top
    }
    
    private func startAnimation() {
           Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
               withAnimation {
//                   activeIndex = (activeIndex + 1) % dotCount
//                   activeIndex = activeIndex == 0 ? 1:0
               }
           }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            withAnimation {
                isScaleUp.toggle()
            }
        }
    }
}

#Preview {
    ZStack{
        Color.white
        
        PinCircleAnimationView(urlImage: nil)
    }
    .ignoresSafeArea()
}
