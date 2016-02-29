//
//  RequestManager+Login.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/29/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

/*
Extension for login and signUp
*/

import Foundation
import Alamofire
import Swift
import SwiftyJSON
import ReachabilitySwift

extension RequestManager {
    func login(username: String, password: String, completion:(([String: AnyObject]?, NSError?) -> ())) {
        if !shouldStartRequest() {
            return
        }
        
        let params = [
            Params.Login.username: username,
            Params.Login.password: password
        ]
        
        Alamofire.request(.POST, url(URL.Login.Login), headers: header(), parameters: params, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                self.endRequest(nil, responseData: nil)
                switch response.result {
                case .Success(let respJSON):
                    let dict = respJSON as? [String: AnyObject]
                    completion(dict, nil)
                    break
                case .Failure(let error):
                    completion(nil, self.errorWithInfo(error, data: response.data!))
                    break
                }
        }
    }
    
    func signUp(username:String, email:String, password:String, confirmPassword:String, fullName:String, hackLicense:String, phone:String, completion:(([String: AnyObject]?, NSError?) -> ())) {
        if !shouldStartRequest() {
            return
        }
        
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
                self.endRequest(nil, responseData: nil)
                switch response.result {
                case .Success(let respJSON):
                    let dict = respJSON as? [String: AnyObject]
                    completion(dict, nil)
                    break
                case .Failure(let error):
                    completion(nil, self.errorWithInfo(error, data: response.data!))
                    break
                }
        }
    }
}