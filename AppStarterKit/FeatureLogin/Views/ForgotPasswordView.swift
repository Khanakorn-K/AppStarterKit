//
//  ForgotPasswordView.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 20/5/2568 BE.
//

import SwiftUI
struct ForgotPasswordView:View {
    @StateObject private var viewModel = ForgotPasswordViewModel()
    @State private var emailText = ""
    @State private var emailStatus : CustomTextField.TextFieldStatus = .normal
    @State private var isValid = true
    @State private var isLoading = false
    @State private var submitButtonDisble = true
    @State private var isPresentedAleartSendEmailForgotPassword = false
    var body: some View {
        ZStack(alignment: .top){
            Color.colorWhite.ignoresSafeArea()
            VStack(spacing: .defaultSpacing4){
                Text("ใส่อีเมลที่ตรงกับ App StarterKit")
                    .bodyFont()
                    .colorTitle()
                textFieldEmail()
                submitButton()
                
            }
            .padding(.defaultSpacing2)
        }
        .withDefaultNavigaitionView()
        .alert("ตรวจสอบรหัสผ่าน\(emailText)", isPresented: $isPresentedAleartSendEmailForgotPassword, actions: {
            Button("ตกลง",role: .cancel){}
        })
        .onReceive(viewModel.$sendEmailStatus){ status in
            guard  status
            else{
                emailStatus = .error(msg: "ไม่พบอีเมล")
                return
            }
            isPresentedAleartSendEmailForgotPassword = true
        }
    }
    private func textFieldEmail()->some View {
        CustomTextField(placeholder: "อีเมล", text:$emailText , status: $emailStatus ,
                        regex: .emailRegax,
                        regexMsg: .errorMsgRegaxEmail,
                        isValid:$isValid)
        .keyboardType(.emailAddress)
        .onChange(of: isValid){
            isValid in submitButtonDisble = isValid.negated
        }
    }
    private func submitButton()->some View {
        DefaultMainColorButtonLoading(isLoading: $isLoading,
                                      buttonDisabled: $submitButtonDisble, title:"ส่ง",isAutoResize: false,action: {
            Task{
                isLoading = true
                try? await viewModel.handleForgotPassword(email:  emailText)
                isLoading = false
            }
        })
        .frame(height:50)
        
    }
}
#Preview {
    ForgotPasswordView()
}
