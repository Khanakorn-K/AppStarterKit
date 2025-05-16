//
//  SetupProfileView.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 15/5/2568 BE.
//
import SwiftUI
import Kingfisher
import SwifterSwift
struct SetupProfileView:View {
    @Environment(\.dismiss) private var dismiss
    @State private var isPresendtedImagePicker = false
    @State private var selectedImage : UIImage?
    @State private var textFieldAliasName = ""
    @State private var isLoadingSetupProfile = false
    @State private var firstAliasName = ""
    private var isChangeData :Bool{
        selectedImage != nil || firstAliasName != textFieldAliasName
    }
    private var isChangeAliasName:Bool{
        firstAliasName !=  textFieldAliasName
    }
    @ObservedObject private var  loginViewModel =  LoginViewModel.shared
    var body: some View {
        ZStack{
            VStack(spacing: .defaultSpacing4){
                ZStack{
                    Button(action: {
                        
                    }, label: {
                        Text("ข้าม")
                            .bodyFont()
                            .colorMainApp()
                    })
                }
                .frame(maxWidth: .infinity,alignment: .trailing)
                VStack(spacing: .defaultSpacing){
                    Text("ตั้งค่าโปรไฟล์")
                        .largeTitleFont()
                        .colorMainApp()
                    Text("เพิ่มรูปโปรไฟล์และชื่อเพื่อแสดงความเป็นคุณ")
                        .bodyFont()
                        .colorTitle()
                }
//                call function
                profileImageView()
                textFieldAliasNameView()
                Spacer()
                buttonSetupProfileView()
            }
            .padding(.defaultSpacing2)
            .onFirstAppear {
                firstAliasName = loginViewModel.socialLoginInfoResponseModel?.name ?? ""
            }
        }
    }
    private func profileImageView()->some View {
        ZStack{
            ImagePickerView(placeholderImageSize:.defaultButtonIcon,isPresented: $isPresendtedImagePicker,
                            selectedImage: $selectedImage,
                            isLockRatio: true
                            ,onImageChange: {image in})
            KFImage(loginViewModel.socialLoginInfoResponseModel?.avatar?.url)
                .resizable()
                .scaledToFit()
                .allowsHitTesting(false )
                .isHidden(selectedImage != nil,remove: false )
        }
        .frame(150)
        .clipShape(Circle())
        .defaultShadow(.defaultShadow)
        .overlay(alignment : .bottomTrailing){
            ZStack{
                Color.white
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: .defaultButtonIcon * 1.8))
                    .foregroundStyle(Color.colorMainApp())
            }
            .frame(.defaultButtonIcon * 2)
            .clipShape(Circle())
        }

    }
    private func textFieldAliasNameView()->some View{
        VStack(alignment: .leading,spacing: .defaultSpacing){
            ZStack{
                TextField("",text:$textFieldAliasName)
                    .bodyFont()
                    .colorWhite()
                    .padding(.defaultSpacing2)
            }
            .background(Color.colorGray3)
            .cornerRadius(.defaultCornerRadius)
            Text("ชื่อห้ามเกิน 18 อักษร")
                .captionFont()
                .colorTitle()
            
        }
        .onFirstAppear {
            textFieldAliasName = loginViewModel.socialLoginInfoResponseModel?.name  ?? ""
        }
    }
    private func buttonSetupProfileView()-> some View {
        DefaultButtonLoading(isLoading : $isLoadingSetupProfile,title: "เริ่มต้น",action: {
            print("name and image:\(isChangeData)")
            Task{
                if isChangeData {
                    try await loginViewModel.handleStartWithSetupProfile(avatar: selectedImage, aliasName: isChangeAliasName ? textFieldAliasName : firstAliasName)
                }
                else{
                    try await loginViewModel.handleSignInAndSaveToken()
                }
                dismiss()
            }
        })
    }
}
#Preview{
    SetupProfileView()
}

