import Foundation

struct LoginRequestBodyModel: Codable{
    
    
    let username:String
    let password:String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
//    init?(verifyCodeEntity: VerifyCodeEntity) {
//        username = verifyCodeEntity.name
//        password = verifyCodeEntity.token
//    }
    
}




// MARK: - MemberInfoResult
struct LoginResponseModel: Codable {
    let result: LoginInfoResponseModel?
    

    enum CodingKeys: String, CodingKey {
        case result = "Result"
    }

}



