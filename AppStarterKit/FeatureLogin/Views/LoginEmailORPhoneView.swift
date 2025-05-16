//
//  LoginEmailORPhone.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 19/5/2568 BE.
//

import SwiftUI
import SegmentedPicker
import NavigationStackBackport
struct LoginEmailORPhoneView:View {
    @ObservedObject private var loginViewModel = LoginViewModel.shared
    private let segmentTitle = ["ใส่เบอร์โทรศัพท์","Email"]
    @State private var selectIndex :Int?
    @State private var isPresendVerifyOTPView = false
    @State private var isPresentedForgotPassword   = false
    var body: some View {
        ZStack{
            VStack(spacing:.defaultSpacing4){
                segmentPickerView()
                ZStack(alignment: .top){
                    LoginWithPhoneView(selectedIndex: $selectIndex)
                        .opacity(selectIndex != 0 ? 0:1)
                    LoginWithEmailView(selectedIndex: $selectIndex, didTapForgotPassword:{isPresentedForgotPassword = true} )
                        .opacity(selectIndex != 1 ? 0:1)
                    
                }
            }
            .padding(.defaultSpacing2)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        //        .background(Color.black)
        .withDefaultNavigaitionView(background: Color.clear)
        .backport.navigationDestination(isPresented: $isPresendVerifyOTPView, destination: {VerifyOTPView()})
        .onReceive(loginViewModel.$subsistResponse.dropFirst()){_ in isPresendVerifyOTPView = true}
        .backport.navigationDestination(isPresented: $isPresentedForgotPassword, destination: {ForgotPasswordView()})
    }
    private func segmentPickerView()->some View {
        SegmentedPicker(segmentTitle, selectedIndex: $selectIndex,
                        selectionAlignment: .bottom,
                        content: {title,isSelected in
            Text(title)
                .bodyFont()
                .foregroundStyle(isSelected ? Color.colorMain : Color.colorGray3)
                .padding(.horizontal,.defaultSpacing2)
                .padding(.vertical,.defaultSpacing)
        }, selection: selectionView)
        .onAppear{
            selectIndex = 0
        }
        .animation(.easeInOut,value: selectIndex)
    }
    private func selectionView()->some View{
        VStack(spacing: 0){
            Spacer()
            Color.colorMain.frame(height: 1)
        }
    }
    
}
struct LoginWithPhoneView:View {
    @ObservedObject private var loginModel = LoginViewModel.shared
    @State private var phoneText = ""
    @State private var textFieldPhoneState : CustomTextField.TextFieldStatus = .normal
    @State private var isValidPhone = true
    @FocusState private var  focusTextField : Bool
    @State private var isLoading = false
    @State private var isDisbleButton = true
    @Binding var selectedIndex : Int?
    
    var body: some View {
        ZStack(){
            VStack(alignment: .leading,spacing : .defaultSpacing4){
                Text("สร้างแอคเคาท์ใหม่ หากยังไม่มี")
                    .bodyFont()
                    .colorGray()
                textFieldPhoneView()
                submitButtonView()
            }
        }
        .frame(maxWidth:.infinity,alignment: .leading)
    }
    private func textFieldPhoneView()->some View{
        CustomTextField(placeholder:"ใส่เบอร์มือถือ", text: $phoneText,status:$textFieldPhoneState,characterLimit: 10,isValid: $isValidPhone)
            .keyboardType(.numberPad)
            .focused($focusTextField)
            .onChange(of: phoneText) {newValue in isDisbleButton = newValue.count == 0}
    }
    private func submitButtonView()-> some View {
        DefaultMainColorButtonLoading(isLoading: $isLoading,
                                      buttonDisabled: $isDisbleButton,
                                      title: "ส่งเพื่อรับ OTP",isAutoResize:false,action: {
            Task{
                do{
                    try? await loginModel.handleSubsist(type:  .phone, phoneOrEmail: phoneText)
                }catch{
                    print(error)
                }
            }
        })
        .frame(height: 50)
    }
    
}
struct LoginWithEmailView:View{
    @ObservedObject private var loginViewModel = LoginViewModel.shared
    @State private var emailText = ""
    @State private var emailStatus : CustomTextField.TextFieldStatus = .normal
    @State private var isValidEmail = true
    @State private var passwordText = ""
    @State private var passwordStatus : CustomTextField.TextFieldStatus = .normal
    @State private var isValidPassword = false
    @State private var isLoading = false
    @State private var isDissbled = false
    @FocusState private var focusTextField : Bool
    @Binding var selectedIndex : Int?
    var didTapForgotPassword : (()->())?
    
    var body: some View{
        ZStack{
            VStack(alignment: .leading,spacing: .defaultSpacing3){
                Text("สร้างแอคเคาท์ใหม่ หากยังไม่มี")
                    .bodyFont()
                    .colorGray()
                VStack(spacing: .defaultSpacing3){
                    textFieldEmailView()
                    textFieldPasswordView()
                    submitButtonView()
                    forgotPasswordButtonView()
                }
                VStack(spacing: .defaultSpacing3){
                    
                }
            }
            .padding(.defaultSpacing2)
        }
        .frame(maxWidth: .infinity,alignment: .topLeading)
        .onReceive(loginViewModel.$subsistResponse.dropFirst()){
            subsist in  guard let subsist = subsist
            else{return}
            guard subsist.isNew.negated, subsist.message == "already"
            else{return}
            Task{
                try? await  loginViewModel.handleSigninAndSaveTokenWhenAlreadyEmail(email: emailText, password: passwordText)
            }
        }
    }
    
    private func textFieldEmailView()->some View{
        CustomTextField(placeholder:"ใส่อีเมล", text: $emailText,status:$emailStatus,characterLimit: 10,isValid: $isValidEmail)
            .focused($focusTextField)
        
    }
    private func textFieldPasswordView()->some View{
        CustomTextField(placeholder:"รหัสผ่าน",
            text: $passwordText,
            status:$passwordStatus,
            isSecuredEnabled:true,
            regex: .passwordRegex,
            regexMsg: .errorMsgRegaxPassword,
            isValid: $isValidPassword
        )
            .focused($focusTextField)
            
        
    }
    private func submitButtonView()-> some View {
        DefaultMainColorButtonLoading(isLoading: $isLoading,buttonDisabled: $isDissbled ,title: "ยืนยัน",isAutoResize: false,action: {
            Task{
                isLoading = true
                try? await loginViewModel.handleSubsist(type: .mail, phoneOrEmail: emailText, password: passwordText)
            }
            isLoading = false
        })
        .frame(height: 50)
    }
    private func forgotPasswordButtonView()->some View {
        Button(action: {
            didTapForgotPassword?()
        }, label: {
            Text("ลืมรหัสผ่าน")
                .bodyFont()
                .colorMainApp()
        })
    }
}

#Preview {
    LoginEmailORPhoneView()
}
