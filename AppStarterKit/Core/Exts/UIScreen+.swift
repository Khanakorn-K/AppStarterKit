//
//  UIScreen+.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 14/11/2566 BE.
//

import Foundation
import UIKit

extension UIScreen{
    static var screenWidth: CGFloat {
        screenSize.width
    }
    
    static var screenHeight: CGFloat {
        screenSize.height
    }
    
    static var screenHeightWithSafeArea: CGFloat {
        screenSize.height - safeArea.top - safeArea.bottom
    }
    
    static var screenSize: CGSize {
        UIApplication.shared.currentWindow?.bounds.size ?? .zero
    }
    
    static var safeArea: UIEdgeInsets {
        UIApplication.shared.currentWindow?.safeAreaInsets ?? .zero
    }
    
    static var scaleFactor: CGFloat {
        UIApplication.shared.currentWindow?.screen.scale ?? 0
    }
    
    static var statusBarHeight: CGFloat {
        UIApplication.shared.currentWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    static func calculateContent(baseScreenWidth: CGFloat, baseContent: CGFloat) -> CGFloat {
        return  screenWidth * baseContent / baseScreenWidth
    }
    
//    static var scale: CGFloat {
//        UIApplication.shared.currentWindow?.sca
//    }
}
