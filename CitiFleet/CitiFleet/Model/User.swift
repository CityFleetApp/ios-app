//
//  User.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/24/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

struct UserKeys {
    static let User = "User"
    static let UserName = "UserName"
    static let FullName = "FullName"
    static let HackLicense = "HackLicense"
    static let Phone = "Phone"
    static let Email = "Email"
    static let Token = "Token"
}

class User: NSObject, NSCoding {
    var userName: String?
    var fullName: String?
    var hackLicense: String?
    var phone: String?
    var email: String?
    var token: String?
    
    private static var currUser: User?
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        userName = aDecoder.decodeObjectForKey(UserKeys.UserName) as? String
        fullName = aDecoder.decodeObjectForKey(UserKeys.FullName) as? String
        hackLicense = aDecoder.decodeObjectForKey(UserKeys.HackLicense) as? String
        phone = aDecoder.decodeObjectForKey(UserKeys.Phone) as? String
        email = aDecoder.decodeObjectForKey(UserKeys.Email) as? String
        token = aDecoder.decodeObjectForKey (UserKeys.Token) as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        let objects = [
            UserKeys.UserName: userName,
            UserKeys.FullName: fullName,
            UserKeys.HackLicense: hackLicense,
            UserKeys.Phone: phone,
            UserKeys.Email: email,
            UserKeys.Token: token
        ]
        
        for field in objects {
            aCoder.encodeObject(field.1, forKey: field.0)
        }
    }
    
    class func currentUser() -> User? {
        let storedUser = NSUserDefaults.standardUserDefaults().objectForKey(UserKeys.User) as? NSData
        if User.currUser == nil && storedUser != nil {
            User.currUser = NSKeyedUnarchiver.unarchiveObjectWithData(storedUser!) as? User
        }
        return User.currUser
    }
    
    //MARK: - LogIn / SignUp
    class func signUp(user:User, password: String, confirmPassword:String, completion:((User?, NSError?) -> ())) {
        User.signUp(user.userName!, password: password, confirmPassword:confirmPassword, fullName: user.fullName!, phone: user.phone!, hackLicense: user.hackLicense!, email: user.email!, completion: completion)
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
            if let error = error {
                completion(nil, error)
                return
            }
            let user = User()
            user.token = userData![Params.Login.token] as? String
//            user.email = userData![Params.Login.email] as? String
//            user.userName = userData![Params.Login.username] as? String
//            user.fullName = userData![Params.Login.fullName] as? String
//            user.hackLicense = userData![Params.Login.hackLicense] as? String
//            user.phone = userData![Params.Login.phone] as? String
            currUser = user
            let data = NSKeyedArchiver.archivedDataWithRootObject(user)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: UserKeys.User)
            completion(user, nil)
        }
    }
    
    class func logout(completion:(Bool, NSError)?) {
        currUser = nil
    }
}
