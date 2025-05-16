//
//  Color+.swift
//  FIrstFullSwiftUI
//
//  Created by Chanchana Koedtho on 29/9/2566 BE.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    
    func lighter(by percentage: CGFloat = 30.0) -> Color {
         return self.adjust(by: abs(percentage) )
     }

     func darker(by percentage: CGFloat = 30.0) -> Color {
         return self.adjust(by: -1 * abs(percentage) )
     }

     func adjust(by percentage: CGFloat = 30.0) -> Color {
         let uiColor = UIColor(self)
         var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
         if uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
             return Color(UIColor(
                 red: min(red + percentage/100, 1.0),
                 green: min(green + percentage/100, 1.0),
                 blue: min(blue + percentage/100, 1.0),
                 alpha: alpha
             ))
         } else {
             return self
         }
     }
    
    var uiColor: UIColor {
        return .init(self)
    }
    
    func toHex() -> String {
        let uiColor = UIColor(self)
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
    
    ///black 0.1
    static let defaultShadowColor = Color.black.opacity(0.1)
    ///main app 0.4
    static let defaultShadowColor2 = Color.colorMainApp().opacity(0.4)
    ///black 0.25
    static let defaultShadowColor3 = Color.black.opacity(0.25)
    ///Orange 0.3
    static let defaultShadowColor4 = Color.colorOrange.opacity(0.3)
    ///black 0.2
    static let defaultShadowColor5 = Color.black.opacity(0.2)
}


extension Array where Element == Color {
    static var mainGardient: [Element] {
        [.colorLightGreen, .colorMainApp()]
    }
    
    ///orange-green
    static var gardient2: [Element] {
        [.colorOrange2, .colorLightGreen2]
    }
    
    ///pink-green
    static var gardient3: [Element] {
        [.colorPink, .colorLightGreen2]
    }
    
    ///black-opacity
    static var gardient4: [Element] {
        [.colorBlack, .clear]
    }
}
