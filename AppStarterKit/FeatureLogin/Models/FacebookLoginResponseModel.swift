//
//  FacebookResponseModel.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 26/11/2566 BE.
//

import Foundation

struct FacebookLoginResponseModel {
    let email, firstName: String
    let id: String
    let lastName, name: String
    let picture: Picture
    let gender: String
    
    
    struct Picture: Codable {
        let data: DataClass
        struct DataClass: Codable {
            let height, isSilhouette: Int
            let url: String
            let width: Int
            
       
            
            init(with dictionary: [String: Any]) {
                height = dictionary["height"] as? Int ?? 0
                isSilhouette = dictionary["is_silhouette"] as? Int ?? 0
                url = dictionary["url"] as? String ?? ""
                width = dictionary["width"] as? Int ?? 0
            }
            
        }
        
        init(with dictionary: [String: Any]) {
            data = DataClass(with: dictionary["data"] as? [String:Any] ?? [:])
        }
      
    }
    
   
    
    init(with dictionary: [String: Any]) {
        
        firstName = dictionary["first_name"] as? String ?? ""
        lastName = dictionary["last_name"] as? String ?? ""
        id = dictionary["id"] as? String ?? ""
        name = dictionary["name"] as? String ?? ""
        picture =  Picture(with: dictionary["picture"] as? [String:Any] ?? [:])
        email = dictionary["email"] as? String ?? ""
        gender = dictionary["gender"] as? String ?? ""
    }
}
