//
//  RequestManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/24/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation
import Alamofire
import Swift
import SwiftyJSON

class RequestManager: NSObject {
    private class func url(apiUrl:String) -> String {
        return URL.BaseUrl + apiUrl
    }
    
    private class func header() -> [String:String] {
        return [Params.Header.contentType: Params.Header.json]
    }
    
    private class func errorWithInfo(error: NSError, data: NSData) -> NSError {
        let errorText = String(data: data, encoding: NSUTF8StringEncoding)
        var userInfo = error.userInfo
        userInfo[Params.Response.serverError] = errorText
        return NSError(domain: error.domain, code: error.code, userInfo: userInfo)
    }
    
    class func login(username: String, password: String, completion:(([String: AnyObject]?, NSError?) -> ())) {
        let params = [
            Params.Login.username: username,
            Params.Login.password: password
        ]
        
        Alamofire.request(.POST, url(URL.Login.Login), headers: header(), parameters: params, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .Success(let respJSON):
                    let dict = respJSON as? [String: AnyObject]
                    completion(dict, nil)
                    break
                case .Failure(let error):
                    completion(nil, error)
                    break
                }
        }
    }
    
    class func signUp(username:String, email:String, password:String, confirmPassword:String, fullName:String, hackLicense:String, phone:String, completion:(([String: AnyObject]?, NSError?) -> ())) {
        let params = [
            Params.Login.username: username,
            Params.Login.email: email,
            Params.Login.passwordConfirm: confirmPassword,
            Params.Login.password: password,
            Params.Login.phone: phone,
            Params.Login.hackLicense: hackLicense,
            Params.Login.fullName: fullName
        ]
        
        Alamofire.request(.POST, url(URL.Login.SignUp), headers: header(), parameters: params, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .Success(let respJSON):
                    let dict = respJSON as? [String: AnyObject]
                    completion(dict, nil)
                    break
                case .Failure(let error):
                    completion(nil, errorWithInfo(error, data: response.data!))
                    break
                }
        }
    }
}
