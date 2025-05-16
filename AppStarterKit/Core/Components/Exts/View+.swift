//
//  View+.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 9/11/2566 BE.
//

import Foundation
import SwiftUI

extension View{
    
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
    
    func toUIHostingController(title:String? = nil) ->  UIHostingController<Self> {
        let host = UIHostingController(rootView: self)
//        host.view.backgroundColor = .clear
        host.title = title
        return host
    }
    
    func toUIHostingController(title:String? = nil, didSizeChange: @escaping ((CGSize)->())) ->  UIHostingController<some View> {
        let host = UIHostingController(rootView: self.readSize(onChange: didSizeChange))
//        host.view.backgroundColor = .clear
        host.title = title
        return host
    }
    
    @MainActor
    func toUIHostingController(title:String? = nil, size: Binding<CGSize>) ->  UIHostingController<some View> {
        let host = UIHostingController(rootView: self.readSize(size: size))
//        host.view.backgroundColor = .clear
        host.title = title
        return host
    }
    
    func toUIViewController(title:String? = nil) -> UIViewController {
        let vc = UIViewController()
        vc.addChild(self)
        vc.title = title
        return vc
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    
    func frame(_ size: CGFloat, alignment: Alignment = .center) -> some View {
        frame(width: size, height: size, alignment: alignment)
    }
    
    @ViewBuilder
    func active(if condition: Bool) -> some View {
        if condition { self }
    }
    
    func printScreenWidth(msg: String = "") -> some View {
        self
            .onAppear{
                print("\(msg )width: \(UIScreen.screenWidth)")
            }
    }
    
//    func printSize(msg: String = "") -> some View {
//        self
//            .readSize{
//                print("\(msg) size: \($0)")
//            }
//    }
//    
//    func clearBackground() -> some View {
//        self.background(BackgroundClearView())
//    }
    
    //Require close navigation view in parent
    func addCloseKeyboardButton(title: String = "ปิด", _ perform: (()->())? = nil) -> some View {
        self
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(action: {
                        UIApplication.shared.endEdit()
                        perform?()
                    }, label: {
                        Text(title)
                            .regularKanit(16)
                            .colorTitle()
                    })
                }
            }
    }
    
    func clearListItem(top: CGFloat = 0, 
                       bottom: CGFloat = 10,
                       leading: CGFloat = 0,
                       trailing: CGFloat = 0,
                       showSeparator: Bool = false) -> some View {
        self
            .listRowSeparator(showSeparator ? .visible : .hidden)
            .listRowInsets(.init(top: top, leading: leading, bottom: bottom, trailing: trailing))
            .listRowBackground(Color.clear)
            .buttonStyle(.borderless)
    }
    
    func defaultShadow(
        color: Color = .defaultShadowColor,
        radius: CGFloat = .defaultShadowRadius,
        x: CGFloat = .defaultShadowX,
        y: CGFloat = .defaultShadowY
    ) -> some View {
        return self.shadow(color: color, radius: radius, x: x, y: y)
    }
    
    func defaultShadow(_ shadowConfig: ShadowConfig) -> some View {
        return self.shadow(color: shadowConfig.color, 
                           radius: shadowConfig.shadowRadius,
                           x: shadowConfig.x,
                           y: shadowConfig.y)
    }
    
    func overlayBorder<S>(_ content: S = Asset.Color.colorGray2.swiftUIColor,
                          lineWidth: CGFloat = .defaultBorder,
                          cornerRadius: CGFloat = .defaultCornerRadius) -> some View where S: ShapeStyle {
        self.overlay{
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(content, lineWidth: lineWidth)
        }
    }
    
    @ViewBuilder
    func overlayBorder(_ colors: [Color],
                       lineWidth: CGFloat = .defaultBorder,
                       cornerRadius: CGFloat = .defaultCornerRadius,
                       if condition: Bool = true) -> some View {
        self.overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(LinearGradient(colors: condition ? colors:[.clear], startPoint: .leading, endPoint: .trailing), lineWidth: lineWidth)
        }
    }
    
    func overlayBorder<S>(_ content: S,
                              lineWidth: CGFloat = .defaultBorder,
                              _ colors: [Color]) -> some View where S: Shape {
        self.overlay{
            content
                .stroke(LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing), lineWidth: lineWidth)
        }
    }
    
    func overlayBorder<S, ST>(_ content: S,
                              lineWidth: CGFloat = .defaultBorder,
                              color: ST = Asset.Color.colorGray2.swiftUIColor) -> some View where S: Shape, ST: ShapeStyle {
        self.overlay{
            content
                .stroke(color, lineWidth: lineWidth)
        }
    }
    
    func transparentScrolling() -> some View {
        if #available(iOS 16.0, *) {
            return scrollContentBackground(.hidden)
        } else {
            return onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
    
//    @MainActor
//    func onTapGestureWithLogin(beforeLogin: (()->())? = nil, onCancel: (()->())? = nil, action: (()->())?) -> some View {
//        self.onTapGesture {
//            Task {
//                if await LoginViewModel.shared.isLogin.negated {
//                    beforeLogin?()
//                }
//               
//                LoginViewModel.shared.setupRequireLogin(onCancel: onCancel, action: action)
//            }
//        }
//    }
    
//    @MainActor 
//    func onLoginChange(_ handler: ((Bool)->())?) -> some View {
//        self.onReceive(LoginViewModel.shared.$isLoginPublished.dropFirst()) {
//            handler?($0)
//        }
//    }
    
    @ViewBuilder
    func transition(if condition: Bool, _ transition: AnyTransition) -> some View {
        if condition {
            self.transition(transition)
        } else {
            self
        }
    }
    
    func setGeometryReaderPreferrance<K : PreferenceKey>(key: K.Type = K.self, value: K.Value) -> some View {
        self
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: key,
                                    value: value)
                }
            }
    }
    
    func getRect() -> CGRect {
        UIScreen.main.bounds
    }
    
    func safeAreaInsets() -> UIEdgeInsets {
        UIApplication.shared.currentWindow?.safeAreaInsets ?? .zero
    }
}

//Shadow
extension View {
    func backgroundShadow<S: ShapeStyle>(color: Color = .defaultShadowColor,
                                         cornerRadiuns: CGFloat = .defaultCornerRadius,
                                         shadowRadius: CGFloat = .defaultShadowRadius,
                                         x: CGFloat = .defaultShadowX,
                                         y: CGFloat = .defaultShadowY,
                                         fill: S = .white.opacity(0.1)) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: cornerRadiuns)
                .fill(fill)
                .defaultShadow(color: color,
                               radius: shadowRadius,
                               x: x,
                               y: y)
        )
    }
    
    func backgroundShadow<S: ShapeStyle,
                          ContentShape: Shape>(color: Color = .defaultShadowColor,
                                               cornerRadiuns: CGFloat = 0,
                                               shadowRadius: CGFloat = .defaultShadowRadius,
                                               x: CGFloat = .defaultShadowX,
                                               y: CGFloat = .defaultShadowY,
                                               fill: S = .white.opacity(0.1),
                                               shape: ContentShape) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: cornerRadiuns)
                .fill(fill)
                .clipShape(shape)
                .defaultShadow(color: color,
                               radius: shadowRadius,
                               x: x,
                               y: y)
        )
    }
    
    func backgroundShadow<S: ShapeStyle>(_ shadowConfig: ShadowConfig,
                                         cornerRadiuns: CGFloat = .defaultCornerRadius,
                                         fill: S = .white.opacity(0.1)) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: cornerRadiuns)
                .fill(fill)
                .defaultShadow(color: shadowConfig.color,
                               radius: shadowConfig.shadowRadius,
                               x: shadowConfig.x,
                               y: shadowConfig.y)
                .ignoresSafeArea()
        )
    }
    
    func backgroundShadow(_ shadowConfig: ShadowConfig,
                                         cornerRadiuns: CGFloat = .defaultCornerRadius,
                                         fill: LinearGradient) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: cornerRadiuns)
                .fill(fill)
                .defaultShadow(color: shadowConfig.color,
                               radius: shadowConfig.shadowRadius,
                               x: shadowConfig.x,
                               y: shadowConfig.y)
                .ignoresSafeArea()
        )
    }
    
    func backgroundShadow<S: ShapeStyle,
                          ContentShape: Shape>(_ shadowConfig: ShadowConfig,
                                               cornerRadiuns: CGFloat = 0,
                                               fill: S = .white.opacity(0.1),
                                               shape: ContentShape) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: cornerRadiuns)
                .fill(fill)
                .clipShape(shape)
                .defaultShadow(color: shadowConfig.color,
                               radius: shadowConfig.shadowRadius,
                               x: shadowConfig.x,
                               y: shadowConfig.y)
        )
    }
    
    @MainActor
    func snapshot(origin: CGPoint = .zero, size: CGSize) -> UIImage {
        let window = UIWindow(frame: CGRect(origin: origin, size: size))
        let hosting = UIHostingController(rootView: self)
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return hosting.view.renderedImage
    }
    
//    func maskWithMainGradient(colors: [Color] = .mainGardient) -> some View {
//        self.maskShapeStyle(LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
//    }
    
    func paddingBottomSafeArea() -> some View {
        return self.padding(.bottom, UIScreen.safeArea.bottom == 0 ? .defaultSpacing3 : 0)
    }

    func onGeometryChange(coordinateSpace: CoordinateSpace = .global, _ onOffsetChange: @escaping (CGRect) -> Void) -> some View {
        self.background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        // Trigger the offset change when the view appears
                        let frame = geo.frame(in: coordinateSpace)
                        DispatchQueue.main.async {
                            onOffsetChange(frame)
                        }
                    }
                    .onChange(of: geo.frame(in: coordinateSpace)) { newValue in
                        DispatchQueue.main.async {
                            onOffsetChange(newValue)
                        }
                    }
            }
        )
    }
}


struct ShadowConfig {
    let color: Color
    let shadowRadius: CGFloat
    let x: CGFloat
    let y: CGFloat
}


extension ShadowConfig {
    static let defaultShadow = ShadowConfig(color: .defaultShadowColor,
                                            shadowRadius: .defaultShadowRadius,
                                            x: .defaultShadowX,
                                            y: .defaultShadowY)
    
    static let defaultShadowTop = ShadowConfig(color: .defaultShadowColor,
                                               shadowRadius: .defaultShadowRadius,
                                               x: .defaultShadowX,
                                               y: .defaultShadowY2Top)
    
    static func defaultButtonShadow(color: Color = .defaultShadowColor2) -> Self {
        ShadowConfig(color: color,
                     shadowRadius: .defaultShadowRadius2,
                     x: .defaultShadowX2,
                     y: .defaultShadowY2)
    }
    
    static func defaultButtonStrongShadow(color: Color = .defaultShadowColor5) -> Self {
        ShadowConfig(color: color,
                     shadowRadius: .defaultShadowRadius3,
                     x: .defaultShadowX,
                     y: .defaultShadowY3)
    }
    
    static func defaultClearShadow() -> Self {
        ShadowConfig(color: .clear,
                     shadowRadius: 0,
                     x: 0,
                     y: 0)
    }
}
