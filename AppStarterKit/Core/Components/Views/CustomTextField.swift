//
//  SwiftUIView.swift
//  
//
//  Created by Chanchana Koedtho on 14/9/2566 BE.
//

import SwiftUI
import Combine
import SwiftUIIntrospect

extension CustomTextField.TextFieldStatus:Equatable{
    public static func == (lhs: Self, rhs: Self) -> Bool{
        switch (lhs, rhs){
    
        case (.error(msg: _), .error(msg: _)):
            return true
            
        case (.normal, .normal):
            return true
            
        case (.success(_), .success(_)):
            return true
            
        default:
            return false
            
        }
    }
}


public struct CustomTextField:View{
   
    
    public enum TextFieldStatus {
        case success(msg:String)
        case error(msg:String)
        case normal
        
        
        var color:Color{
            switch self{
                
            case .success(msg: _):
                return .green
            case .error(msg: _):
                return .pink
            case .normal:
                return Asset.Color.colorMain.swiftUIColor
                    
            }
        }
        
        var iconName:String{
            switch self {
            case .success(msg: _):
                return ""
            case .error(msg: _):
                return "exclamationmark.circle"
            case .normal:
                return ""
            }
        }
    }
    
    @State var placeholder:String = ""
    @Binding var text:String
    @Binding var status:TextFieldStatus
    @State var isLoading = false
    let characterLimit: Int
    @State private var isSecured = true
    let isSecuredEnabled:Bool
    let regex:String
    let regexMsg:String
    @Binding var isValid:Bool
    var onFocus:((Bool)->())?
    @State private var isFocus = false
    
    
    init(placeholder: String = "",
                  text: Binding<String>,
                  status: Binding<TextFieldStatus>,
                  isLoading: Bool = false,
                  characterLimit: Int = 0,
                  isSecuredEnabled:Bool = false,
         regex:String = "",
         regexMsg:String = "",
         isValid:Binding<Bool>,
         onFocus:((Bool)->())? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self._status = status
        self.isLoading = isLoading
        self.characterLimit = characterLimit
        self.isSecuredEnabled = isSecuredEnabled
        self.regex = regex
        self.regexMsg = regexMsg
        self._isValid = isValid
        self.onFocus = onFocus
    }
    
    public var body: some View{
      
        VStack{
            
            ZStack{
                VStack{
                    if isSecured, isSecuredEnabled{
                        CustomSecureTextField("",
                                    text: $text,
                                onEditingChanged:{isChanged in
                            onFocus?(isChanged)
                            isFocus = isChanged
                            
                            guard !isChanged, text.count > 0
                            else{
                                return
                            }
                            updateErrorRegexMsg(text)
                            
                        },onCommit: {
                            onFocus?(false)
                            isFocus = false
                            updateErrorRegexMsg(text)
                        })
                        .frame(height: 32)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .modifier(CustomTextFieldModifier(text: $text,
                                                          regex: regex,
                                                          status: $status,
                                                          characterLimit: characterLimit))
                        .foregroundColor(Asset.Color.colorTextTitle.swiftUIColor)
                        .accentColor(Asset.Color.colorTextTitle.swiftUIColor)
                        .placeholder(when: text.isEmpty) {
                            Text(placeholder)
                                .foregroundColor(.gray)
                        }
                       
                    }else{
                        TextField("",
                                  text: $text,
                                  onEditingChanged: {isChanged in
                            onFocus?(isChanged)
                            isFocus = isChanged
                            
                            guard !isChanged, text.count > 0
                            else{
                                return
                            }
                            updateErrorRegexMsg(text)
                            
                        },
                                  onCommit: {
                            updateErrorRegexMsg(text)
                        })
                        .placeholder(when: text.isEmpty) {
                            Text(placeholder)
                                .foregroundColor(.gray)
                        }
                        .foregroundColor(Asset.Color.colorTextTitle.swiftUIColor)
                        .frame(height: 32)
                        .font(FontFamily.Kanit.regular.swiftUIFont(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .modifier(CustomTextFieldModifier(text: $text,
                                                          regex: regex,
                                                          status: $status,
                                                          characterLimit: characterLimit))
                        .accentColor(Asset.Color.colorTextTitle.swiftUIColor)
                        
                    }
                    
                    Divider()
                        .background(status.color)
                }
                .onChange(of: text){
                    UpdateIsValid($0)
                   
                        
                    if status != .normal{
                        status = .normal
                    }
                }
                .onAppear{
                    UpdateIsValid(text)
                }
                
                if(isSecuredEnabled){
                    VStack{
                        Button(action: {
                            isSecured.toggle()
                        }) {
                            Image(systemName: self.isSecured ? "eye.slash" : "eye")
                                .accentColor(.gray)
                        }
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                }
               
            }

         
            
            switch status {
            case .error(let msg),
                    .success(let msg):
                HStack(alignment: .top){
                    Image(systemName: status.iconName)
                        .foregroundColor(status.color)
                    Text(msg)
                        .font(FontFamily.Kanit.regular.swiftUIFont(size: 16))
                        .foregroundColor(status.color)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
            default:
                EmptyView()
            }
            
            
        }
        
        
        
    }
    
    private func UpdateIsValid(_ text:String){
        guard regex.count > 0
        else{return}
        
        guard text.count > 0
        else {
            status = .normal
            isValid = false
            return
        }
                
       
        
        isValid = NSPredicate(format:"SELF MATCHES %@", regex)
            .evaluate(with: text)
    }
    
    private func updateErrorRegexMsg(_ text:String)  {
      
        UpdateIsValid(text)
        
        
        
        guard text.count > 0
        else{return}

        if isValid, !isFocus {
            status = .normal
        }else{
            status = .error(msg: regexMsg)
        }
    }
    
    
  
    
}


struct CustomTextFieldModifier:ViewModifier{
    @Binding var text:String
    let regex:String
    @Binding var status:CustomTextField.TextFieldStatus
    @State var isValid = true
    let characterLimit: Int
    
    func body(content: Content) -> some View {
        content
            .onChange(of: text){ newValue in
             
           
               
                if newValue.count == 0 {
                    status = .normal
                }
                
                if newValue.count > characterLimit, characterLimit > 0 {
                    text = String(newValue.prefix(characterLimit))
                }
            }
    }
    
    
}

struct CustomTextField_Demo:View{
    @State var text:String = ""
    @State var isValid = false
    @State var status:CustomTextField.TextFieldStatus = .normal
    var body: some View{
        CustomTextField(text: $text,
                        status: $status,
                        regex: #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#,
                        regexMsg: "error นะครับ",
                        isValid: $isValid)
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField_Demo()
    }
}
