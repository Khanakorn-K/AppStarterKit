//
//  CustomSegmentControl.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 30/1/2567 BE.
//

import Foundation
import SwiftUI
import CustomizableSegmentedControl

protocol SegmentControlItemProtocol: Hashable & Identifiable{
    var title: String {get}
}

struct CustomSegmentControl<Option: SegmentControlItemProtocol>: View {
    @Binding var selectedSegment: Option
    let options: [Option]
    var customText: ((Option, Bool)) -> (String?)
    
    
    
    var body: some View {
        CustomizableSegmentedControl(selection: $selectedSegment,
                                     options: options,
                                     selectionView: selectionView(),
                                     segmentContent: {option, isSelected, isPressed  in
            
            segmentView(title: customText((option, isPressed)) ?? option.title,
                        imageName: nil,
                        isPressed: isPressed, 
                        option: option)
            .colorMultiply(selectedSegment == option ? .white : Asset.Color.colorTextTitle.swiftUIColor)
            .animation(.easeInOut, value: selectedSegment)
            
        })
        .insets(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
        .segmentedControlContentStyle(.default)
        .background(Color(red: 0.92, green: 0.92, blue: 0.92))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .animation(.easeInOut, value: selectedSegment)
    }
    
    private func selectionView(color: Color = .white) -> some View {
        RoundedRectangle(cornerRadius: 24 - 4)
            .fill(.clear)
            .backgroundShadow(.defaultButtonShadow(),
                              cornerRadiuns: 24 - 4,
                              fill: LinearGradient(colors: .mainGardient, startPoint: .leading, endPoint: .trailing))
        
    }
    
    @ViewBuilder
    private func segmentView(title: String, imageName: String?, isPressed: Bool, option: Option) -> some View {
        HStack(spacing: 4) {
            Text(title)
                .semiBoldKanit(16)
                .foregroundStyle(option == selectedSegment ? .white:.colorTitle())

            imageName.map(Image.init(systemName:))
        }
        .lineLimit(1)
        .padding(.vertical, 5)
        .padding(.horizontal, 5)
        .frame(maxWidth: .infinity)
    }
}
