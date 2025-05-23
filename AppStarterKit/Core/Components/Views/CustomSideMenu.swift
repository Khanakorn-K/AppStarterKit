//
//  CustomSideMenu.swift
//  SlideOutMenu
//
//  Created by MK-Mini on 17/4/2568 BE.
//https://github.com/boardguy1024/SideMenuLikeTwitter

import SwiftUI

struct CustomSideMenu<MainContent: View, SideMenuContent: View>: View {
    
    @Binding var showMenu: Bool
    @Binding var allowGesture: Bool
    @ViewBuilder
    let mainContent: () -> MainContent
    
    @ViewBuilder
    let sideMenuContent: () -> SideMenuContent
    
    // Offset for Both Drag Gestures and showing Menu.
    @State private var offset: CGFloat = 0
    @State private var lastStoredOffset: CGFloat = 0
    
    @GestureState private var gestureOffset: CGFloat = 0
    
    private let sideBarWidth = UIScreen.main.bounds.width - 90
    
    var body: some View {
        ZStack {
            
            HStack(spacing: 0) {
                sideMenuContent()
                
                
                // Main Content
                mainContent()
                .frame(width: getRect().width)
                .overlay(
                    Rectangle()
                        .fill(
                            // offset: 300 / 300 = 1
                            // 1 / 5 = 0.2
                            Color.primary.opacity( (offset / sideBarWidth) / 5.0 )
                        )
                        .ignoresSafeArea(.container, edges: .all)
                        .onTapGesture {
                                showMenu.toggle()
                        }
                        
                )
            }
            // maxWidth : sideBarWidth + screenWidth
            .frame(width: sideBarWidth + getRect().width)
            .offset(x: -sideBarWidth / 2)
            .offset(x: offset)
            .gesture(
                allowGesture ?
                DragGesture()
                    .updating($gestureOffset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded(onEnd(value:))
                : nil
            )

            
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .animation(.linear(duration: 0.15), value: offset == 0)
        .onChange(of: showMenu) { newValue in
            // ここで offsetを使う理由としては、offsetが変わるにつれて背景の黒半透明をAnimationさせるため
            if showMenu && offset == 0 {
                offset = sideBarWidth
                lastStoredOffset = offset
            }
            
            if !showMenu && offset == sideBarWidth {
                offset = 0
                lastStoredOffset = 0
            }
        }
        .onChange(of: gestureOffset) { newValue in
         print("allowGesture",allowGesture)
            if gestureOffset != 0 {
                                
                // Draggingしたwidthが SideBarWidth以内の場合
                if gestureOffset + lastStoredOffset < sideBarWidth && (gestureOffset + lastStoredOffset) > 0 {
                    
                    offset = lastStoredOffset + gestureOffset
                    
                } else {
                    // sideMenuWidth範囲外の場合
                    if gestureOffset + lastStoredOffset < 0 {
                        // Draggingがdeviceの左端を超えた場合には 0で sideMenuを完全にしまう
                        offset = 0
                    }
                }
            }
        }
    }
    
    func onEnd(value: DragGesture.Value) {
                
        withAnimation(.spring(duration: 0.15)) {
            
            if value.translation.width > 0 {
                // Dragging>>>
                
                // 指を離した位置が sideBarWidthの半分を超えた場合
                // (注意: valueは draggingにより 0から始まる
                if value.translation.width > sideBarWidth / 2 {

                    offset = sideBarWidth
                    lastStoredOffset = sideBarWidth
                    showMenu = true
                } else {
                    
                    // sideMenuが開いている状態で右端の方にdraggingした際には誤って閉じないように回避させる
                    if value.translation.width > sideBarWidth && showMenu {
                        offset = 0
                        showMenu = false
                    } else {
                        // velocityによる判定
                        // 指を離した位置が半分以下でも Dragging加速度が早ければ SideMenuを開く
                        if value.velocity.width > 800 {
                            offset = sideBarWidth
                            showMenu = true
                        } else if showMenu == false {
                            // showSideMenu == false状態で、指を離した位置が半分以下なら 元に戻す
                            offset = 0
                            showMenu = false
                        }
                    }
                }
            } else {
                // <<<Dragging
                
                if -value.translation.width > sideBarWidth / 2 {
                    offset = 0
                    showMenu = false
                } else {
                    
                    // sideMenuが閉じている状態で左の方にDraggingする場合には
                    // この処理を回避させる
                    guard showMenu else {
                        return }
                    
                    // 指を離した位置が半分以下でも <<<左のDragging加速度が早ければ sideMenuを閉じる
                    if -value.velocity.width > 800 {
                        offset = 0
                        showMenu = false
                    } else {
                        offset = sideBarWidth
                        showMenu = true
                    }
                                                   
                }
            }
        }
        
        lastStoredOffset = offset
    }
}

