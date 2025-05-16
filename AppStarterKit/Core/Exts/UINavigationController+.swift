//
//  UINavigationController+.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 15/11/2566 BE.
//
//https://stackoverflow.com/a/72489086

import Foundation
import UIKit

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    // Allows swipe back gesture after hiding standard navigation bar with .navigationBarHidden(true).
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
    
    // Allows interactivePopGestureRecognizer to work simultaneously with other gestures.
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
    
    // Blocks other gestures when interactivePopGestureRecognizer begins (my TabView scrolled together with screen swiping back)
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}
