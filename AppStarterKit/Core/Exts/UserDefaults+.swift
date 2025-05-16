//
//  UserDefaults+.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 21/11/2566 BE.
//

import Foundation


enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}

extension UserDefaults{
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
    
    public subscript<Object:Codable>(key:String) -> Object?{
        get{
            do{
                return try getObject(forKey: key, castTo: Object.self)
                
            }catch{
                print(ObjectSavableError.unableToDecode.rawValue + "\n raw string \(value(forKey: key) ?? "n/a")")
                return nil
            }
            
        }
        
        set{
            if let value = newValue{
                do {
                    try setObject(value, forKey: key)
                }catch{
                    print(ObjectSavableError.unableToEncode.rawValue)
                }
               
            }else{
                setValue(nil, forKey: key)
            }
            
           
        }
    }
    
    public subscript<Object:Codable>(key:UserDefaultKey)->Object?{
        get{
            return UserDefaults.standard[key.rawValue]
        }
        
        set{
            UserDefaults.standard[key.rawValue] = newValue
        }
    }
    
    
    
    public subscript(key:String)->Any?{
        get{
            return value(forKey: key)
        }
        
        set{
            
            setValue(newValue, forKey: key)
        }
    }
    
    
    public subscript(key:UserDefaultKey)->Any?{
        get{
            return UserDefaults.standard[key.rawValue]
        }
        
        set{
            UserDefaults.standard[key.rawValue] = newValue
        }
    }
    
    
    
    public func setValue(_ value:Any?, forKey key:UserDefaultKey){
        setValue(value, forKey: key.rawValue)
    }
    
    static var appSetting:UserDefaultKey.Type{
        UserDefaultKey.self
    }

}
