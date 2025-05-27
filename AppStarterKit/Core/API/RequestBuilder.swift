//
//  RequestBuilder.swift
//  AppStarterKit
//
//  Created by Chanchana Koedtho on 4/3/2564 BE.
//  Copyright © 2564 BE megazy. All rights reserved.
//

import Foundation
import ClientSecurityV4
import AsyncSwiftConnect
import SwifterSwift


class RequestBuilder {
    private var path:String = ""
    private var version:String = "1.0"
    private var body:Encodable?
    private var header:[String:String] = [:]

    private static var appStatus = false
    
    private var isUseMockUserForPreview = false
    private var isShowLog = false
    private var isUseToken = false
    
    private let requester:Requester
    
    private var file: BoundaryCreater.DataBoundary?
    
    init(requester:Requester) {
        self.requester = requester
        header["language"] = "th"
        header["DeviceID"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        header["Platform"] = "ios"
        header["Signature"] = Bundle.main.bundleIdentifier ?? ""
    }
    
    public static func setupAppStatus(with status:Bool){
        appStatus = status
    }
    
    /// use for endpoint
    public func addEndpoint(with endPoint:APIEndpointProtocal)->RequestBuilder{
        self.path = endPoint.path
        self.version = String(endPoint.version)
        return self
    }
    
    
    public func addBody(with data:Encodable)->RequestBuilder{
        body = data
        
#if DEBUG
        if isShowLog{
            print((try? data.jsonString()) ?? "")
        }
#endif
        return self
    }
    
    public func useToken()->RequestBuilder{
        isUseToken = true
        return self
    }
    
//    public func addChannel(with channel:SignalChannel)->RequestBuilder{
//        header["channel"] = channel.rawValue.asString
//        return self
//    }
    
    public func addFile(_ file: BoundaryCreater.DataBoundary) -> Self {
        self.file = file
        return self
    }
    
    public func showLog(_ isShowLog:Bool = true) -> Self{
        self.isShowLog = isShowLog
        return self
    }
    
    
    public func getLoginStatus() async -> Bool {
        return  await LoginViewModel.shared.isLogin
    }
 
    
    public func build<DataResult:Decodable>() async throws -> DataResult {
        let loginStatus = await getLoginStatus()
        return try await createRequest(isLogin: loginStatus)
    }

    private func createRequest<D: Decodable>(isLogin: Bool) async throws -> D {
#if DEBUG
        if isShowLog {
            print("call api: \(path) | version:\(version) | body: \((try? body?.jsonString()) ?? "n/a")")
        }
#endif
        
        if isUseToken, isLogin, !ProcessInfo.processInfo.isPreview {
            do {
                print("show token1")
                let token = try await NetworkUtils.shared.getToken()
                print("show token2")

                header["Authorize"] = token
                print("use token \(token)")
            } catch {
                header["Authorize"] = "\(error)"
                print("no token error: \(error)")
            }
        }
        
          

        #if DEBUG
        if ProcessInfo.processInfo.isPreview && isUseMockUserForPreview{
            let mockUserToken = await MockUserData.shared.get()
            print("use mock token \(mockUserToken)")
            header["Authorize"] = mockUserToken
        }
        #endif


        var retryCount = 0
        var throwError: CustomError?
        
        while retryCount < 3 {
            do {
                if let file = file {
                    return try await requester.postBoundary(path: path,
                                                            sendParameter: body,
                                                            header: header,
                                                            dataBoundary: file,
                                                            version: version)
                } else {
                    return try await requester.post(path: path,
                                                    sendParameter: body,
                                                    header: header,
                                                    version: version)
                }
            } catch {
                guard let asyncSwiftConnectError = error as? AsyncSwiftConnectError
                else { throw error }
                
                let customError = CustomError(error: asyncSwiftConnectError)
                
                //error list that should try to get api again
                let errorList = [NSURLErrorNetworkConnectionLost, NSURLErrorTimedOut]
                
                guard let nsError = customError.error, nsError.domain == NSURLErrorDomain && errorList.contains(nsError.code)
                else {
                    RequestBuilder.createErrorLogr(with: customError)
                    throw customError
                }
                
                throwError = customError
                retryCount += 1
                
                print("try again \(retryCount) \(path) \(customError.errorInfo ?? "n/a")")
                
                try await Task.sleep(nanoseconds: 1_000_000_000)
            }
        }
        
        RequestBuilder.createErrorLogr(with: throwError)
        
        throw throwError ?? .init(unknowError: "n/a")
    }
    
    static private func createErrorLogr(with result:CustomError?){

      
        if result == nil{
#if DEBUG
            print("result value maybe nil because \(result?.localizedDescription ?? result?.errorInfo ?? "n/a")")
            
#endif
          
        }else{
            if let errorArray = result?.errorInfo?.components(separatedBy: " | ==> "),
               let errorResult = try? errorArray.last?.decoded(as: ErrorResult.self){
                let errorString = errorArray.first?.appending("\n\(errorResult)")
                
#if DEBUG
                print(errorString ?? "n/a")
#endif
                
             

            }else{
                
#if DEBUG
                print(result?.errorInfo ?? "n/a")
#endif
                
              
            }

        }
    }
    
    public func requestTranslateEn(_ isRequest:Bool)->Self{
        guard isRequest else {
            return self
        }
        header["language"] = "th"
        return self
    }
    
   
    
    public func useMockUserForPreview() -> Self{
        isUseMockUserForPreview = true
        return self
    }
}

protocol MockDataProviable: AnyObject {
    var hasRequestToken: Bool { get set }
    var lastToken: String? { get set }
}

actor MockDataManager {
    let mockUserData: MockDataProviable
    
    init(mockUserData: MockDataProviable) {
        self.mockUserData = mockUserData
    }
    
    func setHasRequest() {
        mockUserData.hasRequestToken = true
    }
    
    func setToken(_ value: String?){
        mockUserData.lastToken = value
    }
    
    func hasRequest() -> Bool {
        return mockUserData.hasRequestToken
    }
    
    func getToken() -> String? {
        return mockUserData.lastToken
    }
}

public class MockUserData: MockDataProviable{
    
    
    static var shared = MockUserData()
    
    private lazy var mockDataManager: MockDataManager = {
        .init(mockUserData: MockUserData.shared)
    }()
    
    var hasRequestToken: Bool = false
    var lastToken: String?
    
    init(){
        UserDefaultKey.tokenHost.setValue(EndPointManager.tokenHost)
    }
    
    func get() async -> String {
        
        guard await !mockDataManager.hasRequest()
        else {
            while await mockDataManager.getToken() == nil {
                try! await Task.sleep(nanoseconds: 1_000_000_000)
                break
            }
            
            return await mockDataManager.getToken() ?? ""
        }
        
        await mockDataManager.setHasRequest()
        
        let parameters = try? EndPointManager.mockUserData.jsonString()
        let postData = parameters?.data(using: .utf8)

        var request = URLRequest(url: URL(string: "\(EndPointManager.api)/v1.1/member/signin")!,
                                 timeoutInterval: Double.infinity)
        
        request.addValue("com.megazy.Jertam", forHTTPHeaderField: "Signature")
        request.addValue("ios", forHTTPHeaderField: "Platform")
        request.addValue("420C9369-D60F-4AE3-AB15-28337A515E17", forHTTPHeaderField: "DeviceID")
        request.addValue("th", forHTTPHeaderField: "Language")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
     
       
        let responseSession = try? await URLSession.shared.data(for: request)
        let response = responseSession?.1
        let data = responseSession?.0
        print("preview: \(response?.asHTTPURLResponse?.statusCode ?? -1)")
        print("host: \(EndPointManager.api)")
        
        guard let data = data,
              let result:LoginResponseModel = try? data.jsonObject() as? LoginResponseModel else {
            return "empty mock token"
        }
        
        await self.mockDataManager.setToken(result.result?.token)
        
        print("preview token: \(result.result?.token ?? "")")
        
        return result.result?.token ?? ""
    }
}

enum Localized:String {
    case en
    case th
}




private extension URLResponse {
    var asHTTPURLResponse: HTTPURLResponse? {
        self as? HTTPURLResponse
    }
}
