//
//  VerifyOTPView.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 19/5/2568 BE.
//
import SwiftUI
struct VerifyOTPView:View {
    @ObservedObject private var loginViewModel = LoginViewModel.shared
    @State private var isError = false
    @State private var timeRemaining:Int = 10
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let maxTimerInSecound:Int = 10
    var body: some View {
        ZStack(alignment: .top){
            Color.white.ignoresSafeArea()
            VStack(spacing: .defaultSpacing2){
                titleView()
                customVerifyOTP()
                resendOTPButtonView()
            }
            .padding(.defaultSpacing2)
            
        }
        .frame( maxWidth:.infinity, alignment: .top)
        .withDefaultNavigaitionView()
    }
    private func titleView()->some View {
        VStack(spacing: 0){
            let titleSubsistType = loginViewModel.loginSubsistType == .phone ? "หมายเลข" : "อีเมล"
            Text("รหัส OTP ที่ส่งไป \(titleSubsistType) \(loginViewModel.subsistTextPhoneOREmail ?? "-")")
                .bodyFont()
                .colorTitle()
            Text("รหัสอ้างอิง\(loginViewModel.subsistResponse?.message ?? "-")")
                .captionFont()
                .colorSubTitle()
        }
    }
    private func customVerifyOTP()->some View{
        VStack(spacing:0){
            OTPView(isError: $isError,didCompletionHandler: verifyOTP)
                .frame(height:80)
            if isError{
                HStack(){
                    Text("OTP ไม่ถูกต้อง")
                        .colorRed()
                        .bodyFont()
                }
                .transition(.offset(y:-8))
                .frame(maxWidth:.infinity,alignment: .leading)
            }
        }
        .onReceive(loginViewModel.$setUpProfileModel.dropFirst())
        {setuProfile in
            guard let setuProfile = setuProfile
            else{return}
            if setuProfile.status.negated{
                isError = true
            }
        }
        
    }
    private func resendOTPButtonView()->some View {
        ZStack(){
            Button(action: {
                guard let subsistType = loginViewModel.loginSubsistType else { return  }
                guard let subsistTextPhoneOREmail = loginViewModel.subsistTextPhoneOREmail else { return  }
                timeRemaining =  maxTimerInSecound
                Task{
                    try? await loginViewModel.handleSubsist(type: subsistType, phoneOrEmail:subsistTextPhoneOREmail)
                }
            }, label: {
                let timeText  = timeRemaining > 0 ? "\(timeRemaining)s" : ""
                Text("ส่ง OTP อีกครั้ง \(timeText)")
                    .bodyFont()
                    .foregroundStyle(timeRemaining>0 ? Color.colorTextTitle : .colorMain)
            })
        }
        .frame(maxWidth:.infinity)
        .onReceive(timer){
            _ in if timeRemaining > 0{
                self.timeRemaining -= 1
            }
        }
    }
    private func verifyOTP(otp:String){
        guard let subsistType = loginViewModel.loginSubsistType else { return  }
        guard let phoneOREmail = loginViewModel.subsistTextPhoneOREmail else { return  }
        let refCode = loginViewModel.subsistResponse?.message ?? ""
        Task{
            try? await loginViewModel.handleVerifyOTP(type: subsistType, opt: otp, phoneOrEmail: phoneOREmail, otpRef: refCode )
        }
    }
}
#Preview {
    VerifyOTPView()
}
