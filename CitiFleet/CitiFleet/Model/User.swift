//
//  User.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/24/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation
import AFNetworking

class User: NSObject, NSCoding {
    private struct UserKeys {
        static let User = "User"
        static let UserName = "UserName"
        static let FullName = "FullName"
        static let HackLicense = "HackLicense"
        static let Phone = "Phone"
        static let Email = "Email"
        static let Token = "Token"
        static let AvatarURL = "AvatarURL"
    }
    
    var userName: String?
    var fullName: String?
    var hackLicense: String?
    var phone: String?
    var email: String?
    var token: String?
    var avatarURL: NSURL?
    
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
        if let urlString = aDecoder.decodeObjectForKey(UserKeys.AvatarURL) as? String {
            avatarURL = NSURL(string: urlString)
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        let objects = [
            UserKeys.UserName: userName,
            UserKeys.FullName: fullName,
            UserKeys.HackLicense: hackLicense,
            UserKeys.Phone: phone,
            UserKeys.Email: email,
            UserKeys.Token: token,
            UserKeys.AvatarURL: avatarURL?.absoluteString
        ]
        
        for field in objects {
            aCoder.encodeObject(field.1, forKey: field.0)
        }
    }
    
    func saveUser() {
        if self == User.currUser {
            let data = NSKeyedArchiver.archivedDataWithRootObject(self)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: UserKeys.User)
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
        RequestManager.sharedInstance().signUp(username, email: email, password: password, confirmPassword: confirmPassword, fullName: fullName, hackLicense: hackLicense, phone: phone) { (response, error) -> () in
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
                currUser?.saveUser()
                completion(user, nil)
            }
        }
    }
    
    class func login(username: String, password: String, completion:((User?, NSError?) -> ())) {
        RequestManager.sharedInstance().login(username, password: password) { (userData, error) -> () in
            if let error = error {
                completion(nil, error)
                return
            }
            let user = User()
            user.token = userData![Params.Login.token] as? String
            user.email = userData![Params.Login.email] as? String
            user.userName = userData![Params.Login.username] as? String
            user.fullName = userData![Params.Login.fullName] as? String
            user.hackLicense = userData![Params.Login.hackLicense] as? String
            user.phone = userData![Params.Login.phone] as? String
            
            if let urlString = userData![Params.Login.avatarUrl] as? String {
                user.avatarURL = NSURL(string: urlString)
            }
            
            currUser = user
            currUser?.saveUser()
            completion(user, nil)
        }
    }
    
    class func logout() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(UserKeys.User)
        currUser = nil
    }
    
    func uploadPhoto(image: UIImage) {
        if let data = UIImagePNGRepresentation(image) {
            RequestManager.sharedInstance().uploadPhoto(data)
        }
    }
}
