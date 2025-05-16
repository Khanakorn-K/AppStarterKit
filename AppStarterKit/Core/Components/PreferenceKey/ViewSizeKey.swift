//
//  ViewGeometryKey.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 9/11/2566 BE.
//

import Foundation
import SwiftUI


struct ViewGeometry: ViewModifier {
    
    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geometry in
              Color.clear
                .preference(key: ViewSizeKey.self, value: geometry.size)
            }
        )
    }
}

struct ViewSizeGeometryViewModifier: ViewModifier {
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                  Color.clear
                    .preference(key: ViewSizeKey.self, value: geometry.size)
                }
            )
            .onPreferenceChange(ViewSizeKey.self, perform: { value in
                size = value ?? .zero
            })
    }
}


struct ViewSizeKey: PreferenceKey {
    static var defaultValue: CGSize? = nil
    
    static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
        value = value ?? nextValue()
        
    }
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        self.modifier(ViewGeometry())
            .onPreferenceChange(ViewSizeKey.self) { size in
                onChange(size ?? .zero)
            }
    }
    
    func readSize(size: Binding<CGSize>) -> some View {
        return self
            .modifier(ViewSizeGeometryViewModifier(size: size))
    }
}
