//
//  UserDefaultKey.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 21/11/2566 BE.
//

import Foundation



public enum UserDefaultKey: String {
   
    
    case isfirsttime = "is_first_time"
    case secure
    case tokenHost = "tokenhost"
    case isLogin
    case isDev
    case selectedLanguage
   
}


extension UserDefaultKey {
    func setValue(_ value:Any?){
        UserDefaults.standard.set(value, forKey: self.rawValue)
    }
    
    var value: Any? {
        UserDefaults.standard.value(forKey: self.rawValue)
    }
    
    var bool: Bool {
        UserDefaults.standard.bool(forKey: self.rawValue)
    }
    
    var int: Int {
        UserDefaults.standard.integer(forKey: self.rawValue)
    }
    
    var string: String? {
        UserDefaults.standard.string(forKey: self.rawValue)
    }
    
    
    
    func getObject<T:Decodable>()->T?{
        do{
            return try UserDefaults.standard.getObject(forKey: self.rawValue,
                                                       castTo: T.self)
        }catch{
            return nil
        }
        
    }
}
