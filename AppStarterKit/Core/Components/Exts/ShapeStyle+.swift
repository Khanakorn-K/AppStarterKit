//
//  ShapeStyle+.swift
//  AppStarterKit
//
//  Created by Chanchana on 1/4/2568 BE.
//

import SwiftUI

extension ShapeStyle {
    //main gradient leading to trailing
    static var mainGradientLeadingToTrailing: LinearGradient {
        LinearGradient(colors: .mainGardient, startPoint: .leading, endPoint: .trailing)
    }
    
    static func withColor(_ color: Color) -> LinearGradient {
        LinearGradient(colors: [color], startPoint: .leading, endPoint: .trailing)
    }
}
