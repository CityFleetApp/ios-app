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
        let params = [
            Params.Login.username: username,
            Params.Login.password: password
        ]
        post(URL.Login.Login, parameters: params) { (json, error) in
            completion(json?.dictionaryObject, error)
        }
    }
    
    func signUp(username:String, email:String, password:String, confirmPassword:String, fullName:String, hackLicense:String, phone:String, completion:(([String: AnyObject]?, NSError?) -> ())) {
        let params = [
            Params.Login.username: username,
            Params.Login.email: email,
            Params.Login.passwordConfirm: confirmPassword,
            Params.Login.password: password,
            Params.Login.phone: phone,
            Params.Login.hackLicense: hackLicense,
            Params.Login.fullName: fullName
        ]
        post(URL.Login.Login, parameters: params) { (json, error) in
            completion(json?.dictionaryObject, error)
        }
    }
    
    func resetPassword(currPassword: String, newPassword: String, newConfirmPassword: String, completion: (([String: AnyObject]?, NSError?) -> ())) {
        let params = [
            Params.ResetPassword.currentPassword: currPassword,
            Params.ResetPassword.newPassword: newPassword,
            Params.ResetPassword.newConfirmPassword: newConfirmPassword
        ]
        
        post(URL.Login.ResetPassword, parameters: params) { (json, error) in
            completion(json?.dictionaryObject, error)
        }
    }
}