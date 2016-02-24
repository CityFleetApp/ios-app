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
    
    private static var currUser: User?
    class func currentUser() -> User? {
        return User.currUser
    }
    
    class func signUp(user:User, completion:(User, NSError)) {
        User.signUp(user.userName!, password: user.password!, fullName: user.fullName!, phone: user.phone!, hackLicense: user.hackLicense!, email: user.email!, completion: completion)
    }
    
    class func signUp(username: String, password: String, fullName: String, phone: String, hackLicense: String, email: String, completion:(User, NSError)) {
        
    }
    
    class func login(username: String, password: String, completion:((User, NSError) -> ())) {
        
    }
    
    class func logout(completion:(Bool, NSError)?) {
        
    }
}
