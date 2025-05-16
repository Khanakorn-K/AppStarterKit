//
//  NavigationBarHiddenViewModifier.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 7/1/2567 BE.
//

import Foundation
import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

struct NavigationBarHiddenViewModifier: ViewModifier {
     
    @Weak var navigationController: UINavigationController?
    
    func body(content: Content) -> some View {
        content
            .introspect(.navigationView(style: .stack), 
                        on: .iOS(.v15, .v16, .v17, .v18),
                        scope: [.ancestor]){
                navigationController = $0
                updateNavBar()
            }
    }
    
    private func updateNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
    }
}

extension View {
    func withNavigationBarHidden() -> some View {
        if #available(iOS 16, *) {
            return self
                .navigationBarHidden(true)
                .navigationTitle("")
                .navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
        } else {
            return self.modifier(NavigationBarHiddenViewModifier())
                .navigationBarHidden(true)
                .navigationTitle("")
                .navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
