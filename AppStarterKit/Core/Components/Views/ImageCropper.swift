//
//  ImageCropper.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 10/1/2567 BE.
//

import Foundation
import SwiftUI
import UIKit
import CropViewController

struct ImageCropper: UIViewControllerRepresentable{
    @Binding var image: UIImage
    @Binding var isPresented: Bool
    
    let isLockRatio: Bool
    
    var completionHandler: ((UIImage) -> Void)?
    
    init(image: Binding<UIImage> = .constant(UIImage()),
         isPresented: Binding<Bool>,
         isLockRatio: Bool,
         completionHandler: ((UIImage) -> Void)? = nil) {
        self._image = image
        self._isPresented = isPresented
        self.completionHandler = completionHandler
        self.isLockRatio = isLockRatio
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = context.coordinator
        cropViewController.aspectRatioLockEnabled = isLockRatio
        cropViewController.aspectRatioLockDimensionSwapEnabled = true
        cropViewController.resetAspectRatioEnabled = false
        cropViewController.aspectRatioPreset = isLockRatio ? .presetSquare : .presetOriginal
        return cropViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, CropViewControllerDelegate{
        let parent: ImageCropper
        
        init(_ parent: ImageCropper){
            self.parent = parent
        }
        
        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            withAnimation{
                parent.isPresented = false
            }
            parent.image = image
            parent.completionHandler?(image)
        }
        
        func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
            withAnimation{
                parent.isPresented = false
            }
        }
    }
    
}
