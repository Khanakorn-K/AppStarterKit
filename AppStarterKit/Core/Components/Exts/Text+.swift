//
//  Text+.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 16/11/2566 BE.
//

import Foundation
import SwiftUI

extension Text{
    
    func colorTitle() -> Self{
        self.foregroundColor(Asset.Color.colorTextTitle.swiftUIColor)
    }
    
    func colorSubTitle() -> Self{
        self.foregroundColor(Asset.Color.colorSubTitle.swiftUIColor)
    }
    
    func colorWhite() -> Self{
        self.foregroundColor(.white)
    }
    
    func colorWhiteClear() -> Self{
        self.foregroundColor(.white.opacity(0.001))
    }
    
    func colorClear() -> Self{
        self.foregroundColor(.clear)
    }
    
    func colorMainApp() -> Self{
        self.foregroundColor(Asset.Color.colorMain.swiftUIColor)
    }
    
    func colorRed() -> Self{
        self.foregroundColor(Asset.Color.colorRed.swiftUIColor)
    }
    
    func colorGray() -> Self{
        self.foregroundColor(.gray)
    }
    
    func colorLightGray() -> Self{
        self.foregroundColor(Asset.Color.colorLightGray.swiftUIColor)
    }
    
    func colorLightGray2() -> Self{
        self.foregroundColor(Asset.Color.colorLightGray2.swiftUIColor)
    }
    
    func colorOrange() -> some View{
        self.foregroundStyle(Asset.Color.colorOrange.swiftUIColor)
    }
    
    func colorLightGreen5() -> some View{
        self.foregroundStyle(Color.colorLightGreen5)
    }
    
    func semiBoldKanit(_ size: CGFloat) -> Self {
        self.font(FontFamily.Kanit.semiBold.swiftUIFont(size: size))
    }
    
    func regularKanit(_ size: CGFloat) -> Self {
        self.font(FontFamily.Kanit.regular.swiftUIFont(size: size))
    }
    
    func mediumKanit(_ size: CGFloat) -> Self {
        self.font(FontFamily.Kanit.medium.swiftUIFont(size: size))
    }
    ///default 32
    func largeTitleFont(bold: Bool = false) -> Self {
        bold ? self.semiBoldKanit(.largeTextSize) : self.regularKanit(.largeTextSize)
    }
    
    func large2TitleFont(bold: Bool = false) -> Self {
        bold ? self.semiBoldKanit(.large2TextSize) : self.regularKanit(.large2TextSize)
    }
    
    func titleFont(bold: Bool = false) -> Self {
        bold ? self.semiBoldKanit(.titleTextSize) : self.regularKanit(.titleTextSize)
    }
    
    func bodyFont(bold: Bool = false) -> Self {
        bold ? self.semiBoldKanit(.bodyTextSize) : self.regularKanit(.bodyTextSize)
    }
    
    func body2Font(bold: Bool = false) -> Self {
        bold ? self.semiBoldKanit(.body2TextSize) : self.regularKanit(.body2TextSize)
    }
    
    func headlineFont(bold: Bool = false) -> Self {
        bold ? self.semiBoldKanit(.headlinetextSize) : self.regularKanit(.headlinetextSize)
    }
    
    func captionFont(bold: Bool = false) -> Self {
        bold ? self.semiBoldKanit(.captionTextSize) : self.regularKanit(.captionTextSize)
    }
    
    func caption2Font(bold: Bool = false) -> Self {
        bold ? self.semiBoldKanit(.caption2TextSize) : self.regularKanit(.caption2TextSize)
    }
    
    func veryLarge2Title(bold: Bool = false) -> Self {
        bold ? self.semiBoldKanit(.veryLarge2TextSize) : self.regularKanit(.veryLarge2TextSize)
    }
    
    func veryLargeTitle(bold: Bool = false) -> Self {
        bold ? self.semiBoldKanit(.veryLargeTextSize) : self.regularKanit(.veryLargeTextSize)
    }
}

extension View {
    func colorTitle() -> some View {
        self.foregroundStyle(Asset.Color.colorTextTitle.swiftUIColor)
    }
    
    func colorSubTitle() -> some View {
        self.foregroundStyle(Asset.Color.colorSubTitle.swiftUIColor)
    }
    
    func colorWhite() -> some View {
        self.foregroundStyle(Color.white)
    }
    
    func colorClear() -> some View {
        self.foregroundStyle(Color.clear)
    }
    
    func colorMainApp() -> some View {
        self.foregroundStyle(Asset.Color.colorMain.swiftUIColor)
    }
    
    func colorRed() -> some View {
        self.foregroundStyle(Asset.Color.colorRed.swiftUIColor)
    }
    
    func colorGray() -> some View {
        self.foregroundStyle(.gray)
    }
    
    func colorOrange2() -> some View {
        self.foregroundStyle(Color.colorOrange2)
    }
    
    func colorLightGreen2() -> some View {
        self.foregroundStyle(Color.colorLightGreen2)
    }
    
    func semiBoldKanit(_ size: CGFloat) -> some View  {
        self.font(FontFamily.Kanit.semiBold.swiftUIFont(size: size))
    }
    
    func regularKanit(_ size: CGFloat) -> some View  {
        self.font(FontFamily.Kanit.regular.swiftUIFont(size: size))
    }
    
    func mediumKanit(_ size: CGFloat) -> some View  {
        self.font(FontFamily.Kanit.medium.swiftUIFont(size: size))
    }
    
    func colorOrange() -> some View{
        self.foregroundStyle(Asset.Color.colorOrange.swiftUIColor)
    }
    
    func largeTitleFont(bold: Bool = false) -> some View {
        bold ? self.font(FontFamily.Kanit.semiBold.swiftUIFont(size: .largeTextSize)) : self.font(FontFamily.Kanit.regular.swiftUIFont(size: .largeTextSize))
    }
    
    func titleFont(bold: Bool = false) -> some View {
        bold ? self.font(FontFamily.Kanit.semiBold.swiftUIFont(size: .titleTextSize)) : self.font(FontFamily.Kanit.regular.swiftUIFont(size: .titleTextSize))
    }
    
    func bodyFont(bold: Bool = false) -> some View {
        bold ? self.font(FontFamily.Kanit.semiBold.swiftUIFont(size: .bodyTextSize)) : self.font(FontFamily.Kanit.regular.swiftUIFont(size: .bodyTextSize))
    }
    
    func body2Font(bold: Bool = false) -> some View {
        bold ? self.font(FontFamily.Kanit.semiBold.swiftUIFont(size: .body2TextSize)) : self.font(FontFamily.Kanit.regular.swiftUIFont(size: .body2TextSize))
    }
    
    func headlineFont(bold: Bool = false) -> some View {
        bold ? self.font(FontFamily.Kanit.semiBold.swiftUIFont(size: .bodyTextSize)) : self.font(FontFamily.Kanit.regular.swiftUIFont(size: .bodyTextSize))
    }
    
    func captionFont(bold: Bool = false) -> some View {
        bold ? self.font(FontFamily.Kanit.semiBold.swiftUIFont(size: .captionTextSize)) : self.font(FontFamily.Kanit.regular.swiftUIFont(size: .captionTextSize))
    }
    
    func caption2Font(bold: Bool = false) -> some View {
        bold ? self.font(FontFamily.Kanit.semiBold.swiftUIFont(size: .caption2TextSize)) : self.font(FontFamily.Kanit.regular.swiftUIFont(size: .caption2TextSize))
    }
    
    func color(_ color: Color) -> some View {
        self.foregroundStyle(color)
    }
    
    func tintWithMainColor() -> some View {
        self.tint(Asset.Color.colorMain.swiftUIColor)
    }
    
    func imageBodyFont() -> some View {
        self.font(.system(size: .bodyTextSize))
    }
    
    func imageTitleFont() -> some View {
        self.font(.system(size: .headlinetextSize))
    }
}

extension SwiftUI.Font {
    static func semiBoldKanit(_ size: CGFloat) -> Self {
       FontFamily.Kanit.semiBold.swiftUIFont(size: size)
    }
    
    static func regularKanit(_ size: CGFloat) -> Self {
        FontFamily.Kanit.regular.swiftUIFont(size: size)
    }
    
    static func mediumKanit(_ size: CGFloat) -> Self {
        FontFamily.Kanit.medium.swiftUIFont(size: size)
    }
    
    static func largeTitleFont(bold: Bool = false) -> Self {
        bold ? SwiftUI.Font.semiBoldKanit(.largeTextSize) : SwiftUI.Font.regularKanit(.largeTextSize)
    }
    
    static func large2TitleFont(bold: Bool = false) -> Self {
        bold ? SwiftUI.Font.semiBoldKanit(.large2TextSize) : SwiftUI.Font.regularKanit(.large2TextSize)
    }
    
    static func titleFont(bold: Bool = false) -> Self {
        bold ? SwiftUI.Font.semiBoldKanit(.titleTextSize) : SwiftUI.Font.regularKanit(.titleTextSize)
    }
    
    static func bodyFont(bold: Bool = false) -> Self {
        bold ? SwiftUI.Font.semiBoldKanit(.bodyTextSize) : SwiftUI.Font.regularKanit(.bodyTextSize)
    }
    
    static func body2Font(bold: Bool = false) -> Self {
        bold ? SwiftUI.Font.semiBoldKanit(.body2TextSize) : SwiftUI.Font.regularKanit(.body2TextSize)
    }
    
    static func headlineFont(bold: Bool = false) -> Self {
        bold ? SwiftUI.Font.semiBoldKanit(.headlinetextSize) : SwiftUI.Font.regularKanit(.headlinetextSize)
    }
    
    static func captionFont(bold: Bool = false) -> Self {
        bold ? SwiftUI.Font.semiBoldKanit(.captionTextSize) : SwiftUI.Font.regularKanit(.captionTextSize)
    }
    
    static func caption2Font(bold: Bool = false) -> Self {
        bold ? SwiftUI.Font.semiBoldKanit(.caption2TextSize) : SwiftUI.Font.regularKanit(.caption2TextSize)
    }
    
    static func veryLarge2Title(bold: Bool = false) -> Self {
        bold ? SwiftUI.Font.semiBoldKanit(.veryLarge2TextSize) : SwiftUI.Font.regularKanit(.veryLarge2TextSize)
    }
    
    static func veryLargeTitle(bold: Bool = false) -> Self {
        bold ? SwiftUI.Font.semiBoldKanit(.veryLargeTextSize) : SwiftUI.Font.regularKanit(.veryLargeTextSize)
    }
}

extension FontConvertible.Font {
    static func semiBoldKanit(_ size: CGFloat) -> FontConvertible.Font {
       FontFamily.Kanit.semiBold.font(size: size)
    }
    
    static func regularKanit(_ size: CGFloat) -> FontConvertible.Font {
        FontFamily.Kanit.regular.font(size: size)
    }
    
    static func mediumKanit(_ size: CGFloat) -> FontConvertible.Font {
        FontFamily.Kanit.medium.font(size: size)
    }
    
    static func largeTitleFont(bold: Bool = false) -> FontConvertible.Font {
        bold ? FontConvertible.Font.semiBoldKanit(.largeTextSize) : FontConvertible.Font.regularKanit(.largeTextSize)
    }
    
    static func large2TitleFont(bold: Bool = false) -> FontConvertible.Font {
        bold ? FontConvertible.Font.semiBoldKanit(.large2TextSize) : FontConvertible.Font.regularKanit(.large2TextSize)
    }
    
    static func titleFont(bold: Bool = false) -> FontConvertible.Font {
        bold ? FontConvertible.Font.semiBoldKanit(.titleTextSize) : FontConvertible.Font.regularKanit(.titleTextSize)
    }
    
    static func bodyFont(bold: Bool = false) -> FontConvertible.Font {
        bold ? FontConvertible.Font.semiBoldKanit(.bodyTextSize) : FontConvertible.Font.regularKanit(.bodyTextSize)
    }
    
    static func body2Font(bold: Bool = false) -> FontConvertible.Font {
        bold ? FontConvertible.Font.semiBoldKanit(.body2TextSize) : FontConvertible.Font.regularKanit(.body2TextSize)
    }
    
    static func headlineFont(bold: Bool = false) -> FontConvertible.Font {
        bold ? FontConvertible.Font.semiBoldKanit(.headlinetextSize) : FontConvertible.Font.regularKanit(.headlinetextSize)
    }
    
    static func captionFont(bold: Bool = false) -> FontConvertible.Font {
        bold ? FontConvertible.Font.semiBoldKanit(.captionTextSize) : FontConvertible.Font.regularKanit(.captionTextSize)
    }
    
    static func caption2Font(bold: Bool = false) -> FontConvertible.Font {
        bold ? FontConvertible.Font.semiBoldKanit(.caption2TextSize) : FontConvertible.Font.regularKanit(.caption2TextSize)
    }
    
    static func veryLarge2Title(bold: Bool = false) -> FontConvertible.Font {
        bold ? FontConvertible.Font.semiBoldKanit(.veryLarge2TextSize) : FontConvertible.Font.regularKanit(.veryLarge2TextSize)
    }
    
    static func veryLargeTitle(bold: Bool = false) -> FontConvertible.Font {
        bold ? FontConvertible.Font.semiBoldKanit(.veryLargeTextSize) : FontConvertible.Font.regularKanit(.veryLargeTextSize)
    }
    
    var swiftUIFont: SwiftUI.Font {
        .init(self)
    }
}


extension Color {
    static func colorTitle() -> Self {
        Asset.Color.colorTextTitle.swiftUIColor
    }
    
    static func colorMainApp() -> Self {
        Asset.Color.colorMain.swiftUIColor
    }
    
    
    static func colorGrayApp() -> Self {
        Asset.Color.colorGray.swiftUIColor
    }
    
    
    static func colorWhiteClear() -> Self{
        Color.white.opacity(0.001)
    }
}
