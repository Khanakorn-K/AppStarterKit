//
//  UIView+.swift
//  JERTAM
//
//  Created by Chanchana on 2/7/2567 BE.
//

import Foundation
import UIKit

extension UIView {
    
    @MainActor
    var renderedImage: UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
