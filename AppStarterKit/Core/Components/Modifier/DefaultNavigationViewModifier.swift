//
//  DefaultNavigationViewModifier.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 23/11/2566 BE.
//

import Foundation
import SwiftUI

struct DefaultNavigationView<Content: View,
                             LeftContent: View,
                             RightContent: View,
                             TitleContent: View,
                             ContentBackground: View,
                             NavBackground: View>: View {
  
    let title: String
    let content: () -> (Content)
    let leftContent: () -> LeftContent
    let rightContent: () -> (RightContent)
    let titleContent: () -> (TitleContent)
    let isShowBackButton: Bool
    let background: ContentBackground
    let navigationBackground: NavBackground
    
    var didTapBack: (()->())?
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var minY: CGFloat
    
    private var screenSize: CGSize {
        UIScreen.screenSize
    }
    
    init(title: String = "",
         isShowBackButton: Bool = false,
         background: ContentBackground = Asset.Color.colorGray.swiftUIColor,
         navigationBackground: NavBackground = Color.white,
         minY: Binding<CGFloat> = .constant(0),
         didTapBack: (()->())?,
         @ViewBuilder titleContent:  @escaping () -> (TitleContent) = { EmptyView() },
         @ViewBuilder content: @escaping () -> (Content),
         @ViewBuilder leftContent: @escaping () -> LeftContent = { EmptyView() },
         @ViewBuilder rightContent: @escaping () -> (RightContent) = { EmptyView() }) {
        self.content = content
        self.rightContent = rightContent
        self.title = title
        self.titleContent = titleContent
        self.isShowBackButton = isShowBackButton
        self.background = background
        self.navigationBackground = navigationBackground
        self.didTapBack = didTapBack
        self.leftContent = leftContent
        self._minY = minY
    }
    
    
    var body: some View {
        ZStack{
            background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                nav
                    .zIndex(1)
                
                content()
                    .zIndex(0)
            }
        }
        .withNavigationBarHidden()
    }
    
    @ViewBuilder
    private var nav: some View {
        HStack(spacing: 10) {
            HStack(spacing: .defaultSpacing) {
                if isShowBackButton {
                    ZStack(alignment: .leading) {
                       Image(systemName: "chevron.backward")
                            .font(.system(size: .defaultButtonIcon))
                            .colorMainApp()
                    }
                }
                
                leftContent()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if isShowBackButton {
                    dismiss()
                    didTapBack?()
                }
            }
            
            Spacer()
            
            rightContent()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .overlay(
            
            ZStack{
                if title.count > 0 {
                    Text(title).regularKanit(16).colorTitle()
                } else {
                    self.titleContent()
                }
                
            }
                .frame(width: screenSize.width / 2)
        )
        .padding(.horizontal, 10)
        .background(
            navigationBackground
                .defaultShadow(.defaultButtonShadow(color: minY < 0 ? .defaultShadowColor : .clear))
                .animation(.easeInOut, value: minY)
                .ignoresSafeArea()
        )
    }
}


struct DefaultNavigationViewModifier<LeftContent: View,
                                     RightContent: View,
                                     TitleContent: View,
                                     ContentBackground: View,
                                     NavBackground: View>: ViewModifier {
    
    let title: String
    let isShowBackButton: Bool
    let background: ContentBackground
    let navigationBackground: NavBackground
    @Binding var minY: CGFloat
    var titleContent: () -> (TitleContent)
    var leftContent: () -> (LeftContent)
    var rightContent: () -> (RightContent)
    let didTapBack: (()->())?
   
    
    func body(content: Content) -> some View {
        return GeometryReader{_ in
            DefaultNavigationView(title: title,
                                  isShowBackButton: isShowBackButton,
                                  background: background,
                                  navigationBackground: navigationBackground,
                                  minY: $minY,
                                  didTapBack: didTapBack,
                                  titleContent: titleContent,
                                  content: {
                content
                    .frame(maxHeight: .infinity, alignment: .top)
            },
                                  leftContent: leftContent,
                                  rightContent: rightContent)
        }
    }
}


extension View {
    func withDefaultNavigaitionView<TitleContent: View,
                                    LeftContent: View,
                                    RightContent: View,
                                    ContentBackground: View,
                                    NavBackground: View>
    (title: String = "",
     isShowBackButton: Bool = true,
     background: ContentBackground = Asset.Color.colorGray.swiftUIColor,
     navigationBackground: NavBackground = Color.white,
     minY: Binding<CGFloat> = .constant(0),
     didTapBack: (()->())? = nil,
     @ViewBuilder titleContent: @escaping () -> (TitleContent) = { EmptyView() },
     @ViewBuilder leftContent: @escaping () -> (LeftContent) = { EmptyView() },
     @ViewBuilder rightContent: @escaping () -> (RightContent) = { EmptyView() }) -> some View {
        return self
            .modifier(DefaultNavigationViewModifier(title: title,
                                                    isShowBackButton: isShowBackButton, 
                                                    background: background,
                                                    navigationBackground: navigationBackground,
                                                    minY: minY,
                                                    titleContent: titleContent,
                                                    leftContent: leftContent,
                                                    rightContent: rightContent,
                                                    didTapBack: didTapBack))
    }
}



struct DefaultNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        List{
            ForEach(0..<1000){
                Text("\($0)")
            }
        }
        .withDefaultNavigaitionView(title: "Preview Demo")
    }
}



