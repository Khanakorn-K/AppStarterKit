//
//  SJSegmentedViewControllerUIVIewControllerView.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 9/11/2566 BE.
//

import Foundation
import SJSegmentedViewController
import SwiftUI
import SwiftUIIntrospect
import UIKit
import Combine

@MainActor
class SJSegmentedViewControllerUIVIewControllerViewConfiguration: ObservableObject {
    var sj: (()->(SJSegmentedViewController?))?
    var refresher: ((UIRefreshControl) -> ())?
    var didScroll: ((UIScrollView) -> ())?
    var didHeaderHeightUpdate: ((CGFloat)->())?
    var didConfiguration: ((SJSegmentedViewController)->())?
    var lastSelectIndex = 0
    var headerHeight: CGFloat = 0
    
    deinit {
        print("deinit \(self)")
    }
}

extension View{
    @MainActor
    func asSJUIHostingController(sj: SJSegmentedViewController) -> SJUIHostingController<some View>{
        var scrollView:((UIScrollView?) -> ())?
        let rootView = self
            .introspect(.scrollView,
                        on: .iOS(.v15, .v16, .v17, .v18),
                        scope: .receiver){ introScrollView in
              
                DispatchQueue.main.async {
                    scrollView?(introScrollView)
//                    sj?.resetObserver()
                }
               
                
            }
        return SJUIHostingController(rootView: rootView, scrollView: &scrollView)
    }
}

class SJUIHostingController<Content: View>:UIHostingController<Content>, SJSegmentedViewControllerViewSource{
    
    var scrollView:UIScrollView?
   
    init(rootView: Content, scrollView:inout ((UIScrollView?) -> ())?) {
     
        super.init(rootView: rootView)
        scrollView = {[weak self] in
            self?.scrollView = $0
        }
        
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
       
        return scrollView ?? view
    }
}



