//
//  ButtonLoading.swift
//  
//
//  Created by Chanchana Koedtho on 14/9/2566 BE.
//

import Foundation
import SwiftUI
import SwiftfulLoadingIndicators

struct ButtonLoading<Content, SS, BGContent>:View where Content: View, SS: ShapeStyle, BGContent: View {
   
    @Binding var isLoading: Bool
    @Binding var buttonDisabled: Bool
    
    let title: Content?
    var bgColor: SS
    let bgView: () -> BGContent
    let loadingColor: Color
    let isAutoResize: Bool
    let requireLogin: Bool
    
    var action: (()->())?
    
    @State private var sizeTitle: CGSize = .zero
    
    @EnvironmentObject var loginViewModel: LoginViewModel
   
    
    init(isLoading: Binding<Bool>,
         @ViewBuilder title: @escaping () -> Content? = { EmptyView() },
         bgColor: SS = Asset.Color.colorMain.swiftUIColor,
         buttonDisabled: Binding<Bool> = .constant(false),
         loadingColor: Color = .white,
         isAutoResize: Bool = false,
         requireLogin: Bool = false,
         @ViewBuilder bgView: @escaping () -> BGContent = { EmptyView() },
         action: (() -> ())? = nil) {
        
        self._isLoading = isLoading
        self.title = title()
        self.bgColor = bgColor
        self._buttonDisabled = buttonDisabled
        self.loadingColor = loadingColor
        self.isAutoResize = isAutoResize
        self.requireLogin = requireLogin
        self.action = action
        self.bgView = bgView
    }
    
    
    var body: some View{
      
        Button(action: {
           
           
            if !requireLogin {
                action?()
            } else {
                //loginViewModel.setupRequireLogin(action: action)
            }
            
            
        }){
            ZStack {
                if isLoading {
                    ZStack {
                        LoadingIndicator(animation: .threeBallsBouncing,
                                         color: loadingColor)
                    }
                    .frame(height: sizeTitle.height)
                }
                
                title
                    .readSize{
                        guard $0.width > 0 && $0.height > 0
                        else { return }
                        
                        sizeTitle = $0
                    }
                    .opacity(isLoading ? 0 : 1)
                    .animation(.easeInOut, value: isLoading)
            }
            .setSize(isAutoResize: isAutoResize)
            .contentShape(Rectangle())
         
          
        }
        .buttonStyle(.plain)
        .disabled(buttonDisabled || isLoading)
        .background (
            bgView()
            .background(bgColor)
            .overlay {
                Color.white.opacity(buttonDisabled || isLoading ? 0.3 :0 )
            }
//            .opacity(buttonDisabled || isLoading ? 0.7:1)
        )
    }
    
}

struct DefaultButtonLoading: View {
    @Binding var isLoading: Bool
    let title: String
    let isAutoResize: Bool
    var action: (()->())?
    
    init(isLoading: Binding<Bool>,
         title: String,
         isAutoResize: Bool = true,
         action: (() -> Void)? = nil) {
        self._isLoading = isLoading
        self.title = title
        self.isAutoResize = isAutoResize
        self.action = action
    }
    
    var body: some View {
        ButtonLoading(isLoading: $isLoading,
                      title: {
            Text(title)
                .colorWhite()
                .bodyFont(bold: true)
                .padding(.horizontal, .defaultSpacing4)
                .padding(.vertical, .defaultSpacing2)
        },
                      bgColor: .clear,
                      isAutoResize: true,
                      bgView: {
            Color.mainGradientLeadingToTrailing

        },
                      action: action)
        .cornerRadius(.defaultCornerRadius)
    }
}

struct DefaultMainColorButtonLoading: View {
    @Binding var isLoading: Bool
    @Binding var buttonDisabled: Bool
    
    let title: String
    let isAutoResize: Bool
    var action: (()->())?
    
    init(isLoading: Binding<Bool>,
         buttonDisabled: Binding<Bool> = .constant(false),
         title: String,
         isAutoResize: Bool = true,
         action: (() -> Void)? = nil) {
        self._isLoading = isLoading
        self._buttonDisabled = buttonDisabled
        self.title = title
        self.isAutoResize = isAutoResize
        self.action = action
    }
    
    var body: some View {
        ButtonLoading(isLoading: $isLoading,
                      title: {
            Text(title)
                .colorWhite()
                .bodyFont(bold: true)
                .padding(.horizontal, .defaultSpacing4)
                .padding(.vertical, .defaultSpacing2)
        },
                      bgColor: .colorMain,
                      buttonDisabled: $buttonDisabled,
                      isAutoResize: isAutoResize,
                      action: action)
        .cornerRadius(.defaultCornerRadius)
    }
}

struct ButtonLoading_Demo:View {
    
    @State var isLoading = false
    @State var buttonDisabled = false
    
    var body: some View{
        ButtonLoading(isLoading: $isLoading,
                      title: {},
                      buttonDisabled: $buttonDisabled,
                      action: {
            
        })
    }
}

struct ButtonLoading_Previews: PreviewProvider {
    static var previews: some View {
        ButtonLoading_Demo()
    }
}


private extension View {
    
    @ViewBuilder
    func setSize(isAutoResize: Bool) -> some View{
        if isAutoResize {
            self
        } else {
            self.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
