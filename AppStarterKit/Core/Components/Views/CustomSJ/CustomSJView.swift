//
//  CustomSJView.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 19/1/2567 BE.
//

import Foundation
import SwiftUI
import SJSegmentedViewController
import SwifterSwift

struct CustomSJView<Header:View, SegmentView:View>: UIViewControllerRepresentable{
    
    let header:Header
    let segmentViewControllers:[SegmentView]
    let backgroundColor: Color
 
    @Binding var selectedTabIndex:Int
    
    @State private var headerSize: CGSize = .zero
    
    private var configuration = SJSegmentedViewControllerUIVIewControllerViewConfiguration()
    
    init(selectedTabIndex:Binding<Int>? = nil,
         backgroundColor: Color = .white,
         @ViewBuilder header:@escaping (()->Header),
         segmentViewControllers:[SegmentView]){
        self.header = header()
        self.segmentViewControllers = segmentViewControllers
        _selectedTabIndex = selectedTabIndex ?? .constant(0)
        self.backgroundColor = backgroundColor
    }
    
    func makeUIViewController(context: Context) ->  SJSegmentedViewController {
        let sj = SJSegmentedViewController()
        context.coordinator.sj = sj
        
        let header = self.header.toUIHostingController(size: $headerSize)
        header._disableSafeArea = true
        sj.headerViewController = header
        sj.segmentControllers = segmentViewControllers
            .map{
                let host = $0.asSJUIHostingController(sj: sj)
//                host._disableSafeArea = true
                return host
                
        }
        
        sj.delegate = context.coordinator
        
        sj.segmentedScrollView.backgroundColor = backgroundColor.uiColor
        
        self.configuration.didConfiguration?(sj)
        
        return sj
    }
   
    func updateUIViewController(_ uiViewController: SJSegmentedViewController, context: Context) {
       
        if selectedTabIndex !=  configuration.lastSelectIndex{
            DispatchQueue.main.async {
                uiViewController.setSelectedSegmentAt(selectedTabIndex, animated: true)
                withAnimation {
                    self.configuration.lastSelectIndex = selectedTabIndex
                }
            }
        }
        //        print("update \(selectedTabIndex)")
        
        let headerHeight = headerSize.height.rounded(.down)
        if uiViewController.headerViewHeight != headerHeight {
            uiViewController.headerViewHeight = headerHeight
            UIView.animate(withDuration: 0.25, animations: {
                uiViewController.view.setNeedsLayout()
            }, completion: {
                guard $0
                else { return }
                
                uiViewController.resetObserver()
            })
        }
        
        if self.configuration.headerHeight != uiViewController.headerViewHeight {
            self.configuration.headerHeight = uiViewController.headerViewHeight
            DispatchQueue.main.async {
                self.configuration.didHeaderHeightUpdate?(uiViewController.headerViewHeight)
            }
        }
    }
    
    static func dismantleUIViewController(_ uiViewController: SJSegmentedViewController, coordinator: Coordinator) {
//        uiViewController.resetObserver()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    
    class Coordinator:NSObject, SJSegmentedViewControllerDelegate, UIScrollViewDelegate{
      
        weak var sj: SJSegmentedViewController? {
            didSet {
               DispatchQueue.main.async {
                   if self.parent.configuration.refresher != nil {
                       self.sj?.segmentedScrollView.refreshControl = .init()
                       self.sj?.segmentedScrollView.refreshControl?.addTarget(self, action: #selector(self.refreshAction(_:)), for: .valueChanged)
                       self.sj?.segmentedScrollView.bounces = true
                       
                   }
                   
                   self.sj?.segmentedScrollView.delegate = self
               }
            }
        }
        var parent: CustomSJView
        
        init(parent: CustomSJView<Header, SegmentView>) {
            self.parent = parent
            super.init()
            
            binding()
        }
        
        private func binding() {
            parent.configuration.sj = { [weak self] in
                return self?.sj
            }
        }
        
        @objc func refreshAction(_ sender: UIRefreshControl) {
            // Perform your refresh logic here
            // For example, reload data or fetch new content
            // Once the refresh is complete, endRefreshing()
          
            parent.configuration.refresher?(sender)
            
        }
        
        
        func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
            DispatchQueue.main.async {
                self.parent.selectedTabIndex = index
            }
        }
        
        func didSelectSegmentAtIndex(_ index: Int) {
            print("select idx \(index)")
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            DispatchQueue.main.async {
                self.parent.configuration.didScroll?(scrollView)
            }
            
            guard let sj = self.sj
            else {return}
            
            if scrollView.contentSize.height > sj.view.frame.size.height && scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
                scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x,
                                                    y: scrollView.contentSize.height - scrollView.frame.size.height),
                                            animated: false)
            }
        }
        
    }
    
}

extension CustomSJView{
    func configuration(_ config:((SJSegmentedViewController)->())?) -> Self{
        self.configuration.didConfiguration = config
        return self
    }
    
    func refresher(_ done:@escaping ((UIRefreshControl) -> ())) -> Self {
        self.configuration.refresher = done
        return self
    }
    
    func didScroll(_ perform:((UIScrollView) ->())?) -> Self{
        self.configuration.didScroll = perform
        return self
    }
    
    func didHeaderHeightUpdate(_ perform:((CGFloat) ->())?) -> Self{
        self.configuration.didHeaderHeightUpdate = perform
        return self
    }
}
