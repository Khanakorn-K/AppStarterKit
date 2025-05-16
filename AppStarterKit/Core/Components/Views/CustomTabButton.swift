//
//  CustomTabButton.swift
//  SlideOutMenu
//
//  Created by MK-Mini on 17/4/2568 BE.
//
import SwiftUI


struct CustomTabButton: View {
    @Binding var isSelected: Bool
    let image: ImageResource
    let imageUnselect: ImageResource?
    let text: String
    let badgeCount: Int?
    let badgeColor: Color
    let isMainColorOnSelect: Bool
    
    init(
        isSelected: Binding<Bool>,
        image: ImageResource,
        imageUnselect: ImageResource? = nil,
        text: String,
        badgeCount: Int? = nil,
        badgeColor: Color = .red,
        isMainColorOnSelect: Bool = true
    ) {
        self._isSelected = isSelected
        self.image = image
        self.badgeCount = badgeCount
        self.badgeColor = badgeColor
        self.text = text
        self.isMainColorOnSelect = isMainColorOnSelect
        self.imageUnselect = imageUnselect
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button {
                
                isSelected = true
                
            } label: {
                VStack(spacing: 4) {
                    Image(isSelected ? image : imageUnselect ?? image)
                        .resizable()
                        .renderingMode((!isMainColorOnSelect && isSelected) || imageUnselect != nil ? .original : .template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 23, height: 23)
                        .foregroundColor(isSelected ? .colorMain : .gray)
                        .overlay(alignment: .topTrailing) {
                            // Badge
                            if let count = badgeCount, count > 0 {
                                Text(count > 99 ? "99+" : "\(count)")
                                    .font(FontFamily.Kanit.semiBold.swiftUIFont(size: count > 99 ? 8 : 10))
                                    .foregroundColor(.white)
                                    .frame(minWidth: count > 99 ? 22 : (count > 9 ? 18 : 16))
                                    .frame(height: 16)
                                    .background(badgeColor)
                                    .clipShape(Capsule())
                                    .offset(x: 10, y: -5)
                            }
                        }
                    
                    // Optional: Add text label below icon
                    Text(text)
                        .captionFont()
                        .foregroundColor(isSelected ? .colorMain : .gray)
                }
                .frame(maxWidth: .infinity)
            }
            
           
        }
    }
}

