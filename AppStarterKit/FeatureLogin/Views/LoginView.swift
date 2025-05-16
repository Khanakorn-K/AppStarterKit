//
//  LoginView.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 15/5/2568 BE.
//
import SwiftUI
import RichText
struct LoginView:View{
    @ObservedObject private var viewModel = LoginViewModel.shared
    var onTapButtonEmailOROTP :(()->())?
    var completionHandler:(()->())?
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack(spacing: .defaultSpacing4){
                Asset.Login.icAppIcon.swiftUIImage
                    .resizable()
                    .frame(100)
                VStack(spacing: .defaultSpacing3){
                    Text("สร้างแอคเคาท์หรือล็อกอินเข้าสู่ระบบ")
                        .bodyFont()
                        .colorTitle()
                    logginButtonEmailOrOTPView()
                    logginButtonWithLineView()
                    logginButtonWithAppleIdView()
                    logginButtonWithFacebookView()
                    Spacer()
                    policyView()
                }
                .padding(.horizontal,.defaultSpacing2)
            }
            .frame(maxHeight:.infinity,alignment: .top)
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity,alignment: .top)
    }
    private func logginButtonEmailOrOTPView()-> some View{
        Button(action:{
            onTapButtonEmailOROTP?()
        } ,label: {
            ZStack{
                HStack(spacing: .defaultSpacing2){
                    Asset.Login.icPerson.swiftUIImage
                        .resizable()
                        .padding(.defaultSpacing)
                        .frame(.defaultButtonIcon)
                        .background(
                            Circle()
                                .fill(Color.colorMainApp())
                        )
                    Text("ล็อคอินด้วย OTP หรือ Email")
                        .colorTitle()
                        .bodyFont()
                        .frame(maxWidth: .infinity , alignment: .center)
                }
                .padding(.horizontal,.defaultSpacing2)
                .padding(.vertical,.defaultSpacing)
            }
            .background(Color.colorGray2)
            .cornerRadius(.defaultCornerRadius)
        })
    }
    private func logginButtonWithLineView()-> some View{
        Button(action:{
            Task{
                try? await viewModel.handleLineLogin()
            }
        } ,label: {
            ZStack{
                HStack(spacing: .defaultSpacing2){
                    Asset.Login.icLine.swiftUIImage
                        .resizable()
                        .padding(.defaultSpacing)
                        .frame(.defaultButtonIcon + .defaultSpacing2)
                        .background(
                            Circle()
                                .fill(Color.colorMainApp())
                        )
                    Text("ล็อคอินด้วย LINE")
                        .colorTitle()
                        .bodyFont()
                        .frame(maxWidth: .infinity , alignment: .center)
                }
                .padding(.horizontal,.defaultSpacing2)
                .padding(.vertical,.defaultSpacing)
            }
            .background(Color.colorGray2)
            .cornerRadius(.defaultCornerRadius)
        })
    }
    private func logginButtonWithAppleIdView()-> some View{
        Button(action:{
            Task{
                try? await viewModel.handleAppleLogin()
            }
        } ,label: {
            ZStack{
                HStack(spacing: .defaultSpacing2){
                    Asset.Login.icLogoApple.swiftUIImage
                        .resizable()
                        .padding(.defaultSpacing)
                        .frame(.defaultButtonIcon + .defaultSpacing2)
                        .background(
                            Circle()
                                .fill(Color.colorGray2)
                        )
                    Text("ล็อคอินด้วย Apple Id")
                        .colorTitle()
                        .bodyFont()
                        .frame(maxWidth: .infinity , alignment: .center)
                }
                .padding(.horizontal,.defaultSpacing2)
                .padding(.vertical,.defaultSpacing)
            }
            .background(Color.colorGray2)
            .cornerRadius(.defaultCornerRadius)
        })
    }
    private func logginButtonWithFacebookView()-> some View{
        Button(action:{
            Task{
                try? await viewModel.handleFacebookLogin()
            }
        } ,label: {
            ZStack{
                HStack(spacing: .defaultSpacing2){
                    Asset.Login.icFacebook.swiftUIImage
                        .resizable()
                        .padding(.defaultSpacing)
                        .frame(.defaultButtonIcon + .defaultSpacing2)
                        .background(
                            Circle()
                            //                                .fill(Color.colorMainApp())
                        )
                    Text("ล็อคอินด้วย Facebook")
                        .colorTitle()
                        .bodyFont()
                        .frame(maxWidth: .infinity , alignment: .center)
                }
                .padding(.horizontal,.defaultSpacing2)
                .padding(.vertical,.defaultSpacing)
            }
            .background(Color.colorGray2)
            .cornerRadius(.defaultCornerRadius)
        })
    }
    @ViewBuilder
    private func policyView() -> some View {
        let text = "กดคลิกถัดไป, คุณยอมรับ <a href=\"https://www.jertam.com/privacypolicy\">ข้อกำหนดในการให้บริการ</a> และยินยอมให้ข้อมูลและพฤติกรรมเข้าใจ <a href=\"https://www.jertam.com/privacypolicy\">นโยบายความเป็นส่วนตัว</a> และคุณมีอายุอย่างน้อย 13 ปี"
        
        RichText(html: text)
            .lineHeight(170)
            .imageRadius(10)
            .fontType(.custom(.bodyFont()))
            .foregroundColor(light: Asset.Color.colorTextTitle.swiftUIColor,
                             dark: Asset.Color.colorTextTitle.swiftUIColor)
            .linkColor(light: Color.blue, dark: Color.blue)
            .colorPreference(forceColor: .onlyLinks)
            .linkOpenType(.SFSafariView())
            .customCSS("""
            @font-face {
                font-family: '\(FontFamily.Kanit.regular.name)';
                src: url('\(FontFamily.Kanit.regular.name).ttf') format('truetype'); // name of your font in Info.plist
            }
            
            body {
                font-family: '\(FontFamily.Kanit.regular.name)';
                font-size: \(CGFloat.bodyTextSize)px;
            }
            """)
    }
    
}
#Preview {
    LoginView()
}
