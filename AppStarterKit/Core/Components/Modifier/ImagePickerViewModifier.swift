//
//  ImagePickerViewModifier.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 11/1/2567 BE.
//

import Foundation
import SwiftUI

struct ImagePickerViewModifier: ViewModifier {
    @Binding var isPresentedSelectSourceType: Bool
    @Binding var selectedImage: UIImage?
    
    let isLockRatio: Bool
    let captureMode: UIImagePickerController.CameraCaptureMode
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImageCrop = UIImage()
    @State private var selectedImageCropList: [UIImage] = []
    @State private var isPresentedCropImage = false
    @State private var isPresentedImagePicker = false
   
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresentedImagePicker) { _ in }
            .sheet(isPresented: $isPresentedImagePicker){
                ImagePicker(sourceType: sourceType,
                            selectedImage: $selectedImageCropList,
                            captureMode: captureMode){
                    selectedImageCrop = selectedImageCropList.first ?? .init()
                    
                    guard selectedImageCropList.count > 0
                    else { return }
                    
                    isPresentedCropImage = true
                }
            }
            .onChange(of: isPresentedCropImage) { _ in }
            .sheet(isPresented: $isPresentedCropImage,
                   content: {
                ImageCropper(image: $selectedImageCrop,
                             isPresented: $isPresentedCropImage,
                             isLockRatio: isLockRatio){
                    selectedImage = $0
                }
            })
            .confirmationDialog("เลือกรูป",
                                isPresented: $isPresentedSelectSourceType,
                                actions: {
                Button.init(role: .none, action: {
                    sourceType = .photoLibrary
                    isPresentedImagePicker = true
                }, label: { Text("อัลบั้ม") })
                
                Button.init(role: .none, action: {
                    sourceType = .camera
                    isPresentedImagePicker = true
                }, label: { Text("ถ่ายภาพ") })
                
                Button.init(role: .cancel, action: {
                }, label: {Text("ยกเลิก")})
            })
            .onChange(of: isPresentedSelectSourceType){
                guard $0
                else { return }
            }
            .onAppear{
                UIApplication.shared.endEdit()
            }
    }
}

extension View {
    func imagePicker(isPresented: Binding<Bool>,
                     selectedImage: Binding<UIImage?>,
                     isLockRatio: Bool = true,
                     captureMode: UIImagePickerController.CameraCaptureMode = .photo) -> some View {
        return self.modifier(ImagePickerViewModifier(isPresentedSelectSourceType: isPresented,
                                                     selectedImage: selectedImage,
                                                     isLockRatio: isLockRatio, 
                                                     captureMode: captureMode))
    }
}

#if DEBUG
fileprivate
struct ImagePickerViewDemoView: View {
    @State private var selectedImage: UIImage?
    @State private var isPresentedImagePicker = false
    
    var body: some View {
        Button(action: {
            isPresentedImagePicker = true
        }, label: {
            Text("show picker")
        })
        .imagePicker(isPresented: $isPresentedImagePicker,
                     selectedImage: $selectedImage)
    }
}

#Preview{
    ImagePickerViewDemoView()
}

#endif


struct VideoPickerViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var selectedVDOURL: URL?
    
    @State private var isPresentedImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selelctedVideoURLList = [URL]()
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresentedImagePicker, content: {
                ImagePicker(sourceType: sourceType,
                            selectedVideoURls: $selelctedVideoURLList,
                            captureMode: .video,
                            completionHandler: {
                    selectedVDOURL = selelctedVideoURLList.first
                })
            })
            .confirmationDialog("เลือกรูป",
                                isPresented: $isPresented,
                                actions: {
                Button.init(role: .none, action: {
                    sourceType = .photoLibrary
                    isPresentedImagePicker = true
                }, label: { Text("อัลบั้ม") })
                
                Button.init(role: .none, action: {
                    sourceType = .camera
                    isPresentedImagePicker = true
                }, label: { Text("ถ่ายวิดีโอ") })
                
                Button.init(role: .cancel, action: {
                }, label: {Text("ยกเลิก")})
            })
    }
}

extension View {
    func openVideoPickerView(isPresented: Binding<Bool>, selectedVDOURL: Binding<URL?>) -> some View {
        return self.modifier(VideoPickerViewModifier(isPresented: isPresented,
                                                     selectedVDOURL: selectedVDOURL))
    }
}
