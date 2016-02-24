//
//  User.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/24/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

class User: NSObject {
    var userName: String?
    var fullName: String?
    var password: String?
    var hackLicense: String?
    var phone: String?
    var email: String?
    var token: String?
    
    private static var currUser: User?
    class func currentUser() -> User? {
        return User.currUser
    }
    
    //MARK: - LogIn / SignUp
    class func signUp(user:User, confirmPassword:String, completion:((User?, NSError?) -> ())) {
        User.signUp(user.userName!, password: user.password!, confirmPassword:confirmPassword, fullName: user.fullName!, phone: user.phone!, hackLicense: user.hackLicense!, email: user.email!, completion: completion)
    }
    
    class func signUp(username: String, password: String, confirmPassword: String, fullName: String, phone: String, hackLicense: String, email: String, completion:((User?, NSError?) -> ())) {
        RequestManager.signUp(username, email: email, password: password, confirmPassword: confirmPassword, fullName: fullName, hackLicense: hackLicense, phone: phone) { (response, error) -> () in
            if let error = error {
                completion(nil, error)
            } else {
                let user = User()
                user.token = response![Params.Login.token] as? String
                user.userName = username
                user.fullName = fullName
                user.password = password
                user.hackLicense = hackLicense
                user.phone = phone
                user.email = email
                currUser = user
                completion(user, nil)
            }
        }
    }
    
    class func login(username: String, password: String, completion:((User?, NSError?) -> ())) {
        RequestManager.login(username, password: password) { (userData, error) -> () in
            let user = User()
            user.token = userData![Params.Login.token] as? String
            user.password = password
//            user.email = userData![Params.Login.email] as? String
//            user.userName = userData![Params.Login.username] as? String
//            user.fullName = userData![Params.Login.fullName] as? String
//            user.hackLicense = userData![Params.Login.hackLicense] as? String
//            user.phone = userData![Params.Login.phone] as? String
            currUser = user 
            completion(user, error)
        }
    }
    
    class func logout(completion:(Bool, NSError)?) {
        currUser = nil
    }
}
