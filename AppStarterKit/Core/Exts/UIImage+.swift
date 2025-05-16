//
//  UIImage+.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 25/11/2566 BE.
//

import Foundation
import UIKit
import SwifterSwift

extension UIImage {
    func reduceImageFileSizeAsync() async -> Data {
        var compression = 0.9
        let maxCompression = 0.1
        let maxFileSize = 500 * 1024

        var data = await compressImage(compression: compression)

        while data.count > maxFileSize, compression > maxCompression {
            compression -= 0.1
            data = await compressImage(compression: compression)
        }

        return data
    }
    
    func compressImage(compression: Double) async -> Data {
        return await withUnsafeContinuation { continuation in
            DispatchQueue.global().async {
                if let compressedData = self.jpegData(compressionQuality: CGFloat(compression)) {
                    continuation.resume(returning: compressedData)
                }
            }
        }
    }
    
    func getAverageColor() async -> UIColor? {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                guard let inputImage = CIImage(image: self)
                else {
                    continuation.resume(returning: nil)
                    return
                }
                
                let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
                
                guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector])
                else {
                    continuation.resume(returning: nil)
                    return
                }
                
                guard let outputImage = filter.outputImage
                else {
                    continuation.resume(returning: nil)
                    return
                }
                
                var bitmap = [UInt8](repeating: 0, count: 4)
                let context = CIContext(options: [.workingColorSpace: kCFNull!])
                context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
                
                let color = UIColor(red: CGFloat(bitmap[0]) / 255,
                                    green: CGFloat(bitmap[1]) / 255,
                                    blue: CGFloat(bitmap[2]) / 255,
                                    alpha: CGFloat(bitmap[3]) / 255)
                continuation.resume(returning: color)
            }
        }
    }
    
    func getContrastingColor() async -> UIColor? {
        guard let averageColor = await self.getAverageColor() else { return nil }
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        averageColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Calculate contrast color (invert color)
        let contrastRed = 1.0 - red
        let contrastGreen = 1.0 - green
        let contrastBlue = 1.0 - blue
        
        return UIColor(red: contrastRed, green: contrastGreen, blue: contrastBlue, alpha: alpha)
    }
}
