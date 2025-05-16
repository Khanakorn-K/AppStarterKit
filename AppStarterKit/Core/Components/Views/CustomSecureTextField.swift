//
//  CustomSecureTextField.swift
//  
//
//  Created by Chanchana Koedtho on 15/9/2566 BE.
//

import Foundation
import SwiftUI


struct CustomSecureTextField: UIViewRepresentable {
   

    // 1
    @State var placeholder: String = ""
    @Binding var text: String
    var onCommit:(()->())?
    var onEditingChanged:((Bool)->())?
    
    init(_ placeholder: String = "",
         text: Binding<String>,
         onEditingChanged:((Bool)->())? = nil,
         onCommit:(()->())? = nil) {
        self.placeholder = placeholder
        self._text = text
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }
    
   
     // 2
    func makeUIView(context: UIViewRepresentableContext<CustomSecureTextField>) -> UITextField {
        let tf = UITextField(frame: .zero)
        tf.isUserInteractionEnabled = true
        tf.delegate = context.coordinator
        tf.placeholder = placeholder
        tf.textColor = Asset.Color.colorMain.color
        tf.tintColor = Asset.Color.colorMain.color
        tf.isSecureTextEntry = true
        tf.addTarget(context.coordinator,
                     action: #selector(context.coordinator.editingDidEndOnExit(_:)),
                     for: .editingDidEndOnExit)
        return tf
    }

    func makeCoordinator() -> CustomSecureTextField.Coordinator {
        return Coordinator(text: $text,
                           onEditingChanged: onEditingChanged,
                           onCommit: onCommit)
    }

    // 3
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        
    }
                                       
                                      
                                       

    // 4
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var onEditingChanged:((Bool)->())?
        var onCommit:(()->())?

        init(text: Binding<String>,
             onEditingChanged:((Bool)->())?,
             onCommit:(()->())? = nil) {
            _text = text
            self.onEditingChanged = onEditingChanged
            self.onCommit = onCommit
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            onEditingChanged?(true)
            
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            onEditingChanged?(false)
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return false
        }
        
        
        @objc func editingDidEndOnExit(_ textField: UITextField) {
            onCommit?()
        }
        
        
    }
}
