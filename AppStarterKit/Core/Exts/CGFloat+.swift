//
//  CGFloat+.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 3/2/2567 BE.
//

import Foundation
import UIKit

extension CGFloat {
    var int: Int {
        Int(self)
    }
    
    ///default is 5
    static let defaultSpacing: CGFloat = 5
    
    ///default is 10
    static let defaultSpacing2: CGFloat = 10
    
    ///default is 20
    static let defaultSpacing3: CGFloat = 20
    
    ///default is 30
    static let defaultSpacing4: CGFloat = 30
    
    ///default is 10
    static let defaultCornerRadius: CGFloat = 10
    
    ///default is 25
    static let defaultNavIcon: CGFloat = 25
    
    ///default is 25
    static let headerIconSize: CGFloat = 48
    
    static let imageFontSize: CGFloat = 22
  
    ///default 100
    static var veryLargeTextSize: CGFloat {
        getSize(100)
    }
    
    ///default 60
    static var veryLarge2TextSize: CGFloat {
        getSize(60)
    }
    
    ///default 32
    static var largeTextSize: CGFloat {
        getSize(32)
    }
    
    ///default 24
    static var large2TextSize: CGFloat {
        getSize(24)
    }
    
    ///default 20
    static var titleTextSize: CGFloat {
        getSize(20)
    }
    
    ///default 17
    static var headlinetextSize: CGFloat {
        getSize(17)
    }
    
    ///default 16
    static var bodyTextSize: CGFloat {
        getSize(16)
    }
    ///default 14
    static var body2TextSize: CGFloat {
        getSize(14)
    }
    ///default 13
    static var captionTextSize: CGFloat {
        getSize(13)
    }
    ///default 12
    static var caption2TextSize: CGFloat {
        getSize(12)
    }
    
    ///default 7
    static var defaultShadowRadius: CGFloat = 7
    ///default 2.5
    static var defaultShadowRadius2: CGFloat = 2.5
    ///default 1
    static var defaultShadowRadius3: CGFloat = 1
    
    ///default 5
    static let defaultShadowY: CGFloat = 5
    
    ///default 2
    static let defaultShadowY2: CGFloat = 2
    
    ///default 2
    static let defaultShadowY2Top: CGFloat = -2
    
    ///default 5
    static let defaultShadowY3: CGFloat = 5
    
    ///default 0
    static let defaultShadowX: CGFloat = 0
    
    ///default 2
    static let defaultShadowX2: CGFloat = 2
    
    private static func getSize(_ base: CGFloat) -> CGFloat {
        UIScreen.calculateContent(baseScreenWidth: 414, baseContent: base)
    }
    
    ///default is 25
    static let defaultButtonIcon: CGFloat = 25
    
    ///default is 60
    static let defaultAvatarLargeSize: CGFloat = 60
    
    ///default is 40
    static let defaultAvatarSize: CGFloat = 40
    
    ///default is 30
    static let defaultAvatar2Size: CGFloat = 30
    
    ///default is 2
    static let defaultBorder: CGFloat = 2
    
    ///default is 1
    static let defaultBorder2: CGFloat = 1
    
    /// small icon 13
    static let defaultSmallIconSize: CGFloat = 13
    
    /// medium icon 16
    static let defaultMediumIconSize: CGFloat = 16
    
    /// large icon 20
    static let defaultLargeIconSize: CGFloat = 20
    
    /// large icon 70
    static let defaultPopupIcon: CGFloat = 70
}
