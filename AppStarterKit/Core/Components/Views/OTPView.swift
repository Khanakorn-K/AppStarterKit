//
//  OTPView.swift
//
//
//  Created by Chanchana Koedtho on 15/9/2566 BE.
//

import SwiftUI

struct OTPView: View {
   
    
    @State private var numbers = [
        "",
        "",
        "",
        "",
        "",
        ""
    ]
    
    @State private var bottomLinesBg:[Color] = [
        Asset.Color.colorTextTitle.swiftUIColor,
        Asset.Color.colorTextTitle.swiftUIColor,
        Asset.Color.colorTextTitle.swiftUIColor,
        Asset.Color.colorTextTitle.swiftUIColor,
        Asset.Color.colorTextTitle.swiftUIColor,
        Asset.Color.colorTextTitle.swiftUIColor,
    ]
    
    @State private var focusStates:[Bool] = [
        true,
        false,
        false,
        false,
        false,
        false
    ]
    private var lastIndex:Int{
        numbers.lastIndex(where:  {$0.isEmpty.negated}) ?? -1
    }
 
    @Binding var isError:Bool
    var didCompletionHandler:((String)->())?
    
   
    
    var body: some View {
        ZStack{
            
          
            HStack(spacing: 8){
                ForEach(0..<6){idx in
                    VStack{
                        TextFieldFocusView(text: $numbers[idx],
                                           isFirstResponder: $focusStates[idx],
                                           onChange: {newValue in
                        
                         
                            print("update \(newValue ?? "-") | \(numbers) | \(focusStates)\n===========\nlast idx: \(lastIndex)")
                            
                           
                          
                            
                            guard let newValue = newValue,
                                    newValue.isEmpty.negated
                            else{
                                
                                guard lastIndex >= 0
                                else { return }

                                
                                focusStates[lastIndex + 1] = false
                                focusStates[lastIndex] = true
                                numbers[lastIndex] = ""
                                updateBottomline()
                                print("delete")
                                
                                
                                return
                            }
                            
                            updateBottomline()
                            
                            //check is otp input
                            guard newValue.count != 6
                            else {
                                newValue.enumerated().forEach{i, item in
                                    numbers[i] = String(item)
                                }
                                UIApplication.shared.endEdit()
                               
                                return
                            }
                            
                            
                            guard newValue.count == 1
                            else {
                                
                                guard numbers.last?.isEmpty ?? false
                                else {
                                    numbers[numbers.count - 1] = String(newValue.prefix(1))
                                    return
                                }
                                
                                newValue.enumerated().forEach{i, item in
                                    let nextIndex = lastIndex + i
                                    
                                    guard nextIndex < numbers.count
                                    else { return }
                                   
                                    numbers[nextIndex] = String(item)
                                }
                                
                                guard lastIndex + 1 < numbers.count
                                else { return }
                             
                                focusStates[lastIndex + 1] = true
                                return
                            }
                         
                            
                          
                            let nextIndex = lastIndex + 1
                            
                       
                        
                            guard nextIndex < numbers.count
                            else{
                                
                                guard nextIndex == numbers.count,
                                    idx == numbers.count - 1
                                else { return }
                                
                              
//                                didCompletionHandler?(numbers.joined())
                              
                                print(nextIndex)
                                return
                            }
                            
                          
                            focusStates[lastIndex + 1] = true
                            
                        }, didReceiveOTP: {otp in
                            otp.enumerated().forEach{i, item in
                                numbers[i] = String(item)
                            }
                        })
                        .frame(height: 44)
                        .allowsHitTesting(false)
                          
                        Divider()
                            .background(isError ?  .red : bottomLinesBg[idx])
                    }
                }
               
            }
          
            
            
            Button(action: {
//                print(numbers)
            
                isError = false
                let indexLastHasValue = numbers.lastIndex(where: {$0.isEmpty.negated})
                guard let indexLastHasValue = indexLastHasValue
                else {
                    focusStates[0] = true
                    return
                }

                let nextIndex = indexLastHasValue + 1

                guard nextIndex < numbers.count
                else{
                    focusStates[numbers.count - 1] = true
                    return
                }

              
                focusStates[nextIndex] = true
            }){
                Color.clear
            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
          
        }
        .onChange(of: numbers){newValue in
            guard newValue.map({$0.count == 1}).filter({$0}).count == 6
            else { return }
            print(newValue)
            UIApplication.shared.endEdit()
            didCompletionHandler?(newValue.joined())
        }
        .onAppear{
            focusStates[0] = true
        }
//        .frame(maxHeight: .infinity)
      
    }
    
    
    private func updateBottomline(){
        bottomLinesBg.enumerated().forEach{i, item in
            
            bottomLinesBg[i] = i <= lastIndex ? Asset.Color.colorMain.swiftUIColor:Asset.Color.colorTextTitle.swiftUIColor
                
        }
    }
}

struct OTPView_Demo:View{
    @State private var isError = false
    var body: some View{
        OTPView(isError: $isError)
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView_Demo()
    }
}
