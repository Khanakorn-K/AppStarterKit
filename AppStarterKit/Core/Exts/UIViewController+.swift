//
//  UIViewController+.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 9/11/2566 BE.
//

import Foundation
import UIKit
import SwiftUI

extension UIViewController{
    @discardableResult
    func addChild<Content>(_ view:Content) -> Self where Content:View{
        let host = view.toUIHostingController()
        addChild(host)
        self.view.addSubview(host.view)
       
        // Disable translatesAutoresizingMaskIntoConstraints
        host.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints using UIKit's native constraint API
        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            host.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            host.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            host.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        host.didMove(toParent: self)
        
        return self
    }
    
    var topViewController: UIViewController {
        if let navigationController = self as? UINavigationController {
            return navigationController.viewControllers.last?.topViewController
            ?? navigationController
                .visibleViewController ?? navigationController
        }
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topViewController ?? tabBarController
        }
        if let presented = presentedViewController {
            if presented.isBeingDismissed {
                return self
            } else {
                return presented.topViewController
            }
        }
        return self
    }
}
