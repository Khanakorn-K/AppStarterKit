//
//  ImagePickerView.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 12/3/2567 BE.
//

import SwiftUI

struct ImagePickerView: View {
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage?
    
    @State private var isPresentedImagePicker = false
    @State private var selectedImagePicker: UIImage?
 
    let placeholder: String
    let placeholderImageSize: CGFloat
    let isLockRatio: Bool
    let bgColor: Color
    
    var onImageChange: ((UIImage)->())?
    
    init(_ placeholder: String = "",
         placeholderImageSize: CGFloat = 50,
         isPresented: Binding<Bool> = .constant(false),
         selectedImage: Binding<UIImage?> = .constant(nil),
         isLockRatio: Bool = true,
         bgColor: Color = .white,
         onImageChange: ((UIImage)->())? = nil) {
        self.placeholder = placeholder
        self._isPresented = isPresented
        self.onImageChange = onImageChange
        self._selectedImage = selectedImage
        self.placeholderImageSize = placeholderImageSize
        self.isLockRatio = isLockRatio
        self.bgColor = bgColor
    }
    
    var body: some View {
        Button(action: {
            isPresentedImagePicker = true
        }, label: {
            Group{
                if let image = selectedImagePicker {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                  RoundedRectangle(cornerRadius: 10)
                        .fill(bgColor)
                        .overlay(alignment: .center){
                            VStack(spacing: 20){
                                Asset.icCamera.swiftUIImage
                                    .resizable()
                                    .frame(placeholderImageSize)
                                
                                if placeholder.count > 0 {
                                    Text(placeholder)
                                        .bodyFont()
                                        .colorGray()
                                }
                            }
                        }
                        .aspectRatio(1, contentMode: .fit)
                }
            }
        })
            .imagePicker(isPresented: $isPresentedImagePicker,
                         selectedImage: $selectedImagePicker,
                         isLockRatio: isLockRatio)
            .onChange(of: isPresentedImagePicker){
                isPresented = $0
            }
            .onChange(of: isPresented) {
                isPresentedImagePicker = $0
            }
            .onChange(of: selectedImagePicker) {
                selectedImage = $0
                
                guard let image = $0
                else { return }
                
                onImageChange?(image)
            }
            .onChange(of: selectedImage) {
                selectedImagePicker = $0
                
                guard let image = $0
                else { return }
                
                onImageChange?(image)
            }
    }
}

#Preview {
    ImagePickerView("เพิ่มรูป")
}
