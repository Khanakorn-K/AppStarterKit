//
//  TextFieldFocusView.swift
//  
//
//  Created by Chanchana Koedtho on 15/9/2566 BE.
//

import Foundation
import SwiftUI
import UIKit

@MainActor
struct TextFieldFocusView: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFirstResponder: Bool
    var onChange: ((String?) -> Void)? = nil
    var onFocus: ((Bool) -> Void)? = nil
    var didReceiveOTP: ((String) -> Void)? = nil

    func makeUIView(context: Context) -> UITextField {
        let textField = TextFieldWithBackspace()
        textField.backspaceCalled = {
            DispatchQueue.main.async {
                onChange?(nil)
            }
        }
        textField.delegate = context.coordinator
        textField.font = FontFamily.Kanit.semiBold.font(size: 24)
        textField.textColor = Asset.Color.colorMain.color
        textField.textAlignment = .center
        textField.addTarget(context.coordinator,
                            action: #selector(Coordinator.textFieldDidChange),
                            for: .editingChanged)
        textField.keyboardType = .numberPad
//        textField.textContentType = .oneTimeCode
        textField.tintColor = Asset.Color.colorMain.color
        
     
        
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
     
        if isFirstResponder {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
            }
            
        } else {
//            DispatchQueue.main.async {
//                uiView.resignFirstResponder()
//            }
        }
        
        if uiView.text != self.text {
            uiView.text = self.text
            
            if text.count == 0{
                uiView.tintColor = Asset.Color.colorMain.color
            }
        }
       
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: TextFieldFocusView

        init(_ parent: TextFieldFocusView) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.parent.text = String(textField.text ?? "")
            }
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.parent.onFocus?(true)
            }
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.parent.isFirstResponder = false
                self.parent.onFocus?(false)
            }
           
        }
       
       
        
        @objc func textFieldDidChange(_ textField: UITextField) {
          
            DispatchQueue.main.async {
                guard let text = textField.text, text.isEmpty.negated
                else {
                    textField.tintColor = Asset.Color.colorMain.color
                    return
                }
               
                self.parent.onChange?(textField.text ?? "")
                
                textField.tintColor = .clear
            }
            
        }
        
       
    }
}


class TextFieldWithBackspace:UITextField{
    var backspaceCalled: (()->())?
    override func deleteBackward() {
        super.deleteBackward()
        backspaceCalled?()
    }
}
