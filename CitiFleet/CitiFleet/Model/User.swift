//
//  User.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/24/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation
import AFNetworking

struct Profile {
    var carMake: Int?
    var carModel: Int?
    var bio: String?
    var username: String?
    var carYear: Int?
    var carType: Int?
    var phone: String?
    var carColor: Int?
    var carMakeDisplay: String?
    var carModelDisplay: String?
    var carColorDisplay: String?
    var carTypeDisplay: String?
}

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
    var bio: String?
    var drives: String?
    
    var profile = Profile()
    
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
    
    func loadProfile(completion: ((NSError?) -> ())) {
        typealias Param = Response.UserInfo.Profile
        RequestManager.sharedInstance().getProfile { [weak self] (response, error) in
            if error != nil || response == nil {
                completion(error)
                return
            }
            self?.profile.bio = response![Param.bio] as? String
            self?.profile.carColor = response![Param.carColor] as? Int
            self?.profile.carColorDisplay = response![Param.carColorDisplay] as? String
            self?.profile.carMake = response![Param.carMake] as? Int
            self?.profile.carMakeDisplay = response![Param.carMakeDisplay] as? String
            self?.profile.carModel = response![Param.carModel] as? Int
            self?.profile.carModelDisplay = response![Param.carModelDisplay] as? String
            self?.profile.carType = response![Param.carType] as? Int
            self?.profile.carTypeDisplay = response![Param.carTypeDisplay] as? String
            self?.profile.carYear = response![Param.carYear] as? Int
            self?.profile.phone = response![Param.phone] as? String
            self?.profile.username = response![Param.username] as? String
            completion(nil)
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
            user.token = userData![Response.UserInfo.Token] as? String
            user.email = userData![Response.UserInfo.Email] as? String
            user.userName = userData![Response.UserInfo.Username] as? String
            user.fullName = userData![Response.UserInfo.FullName] as? String
            user.hackLicense = userData![Response.UserInfo.HackLicense] as? String
            user.phone = userData![Response.UserInfo.Phone] as? String
            user.bio = userData![Response.UserInfo.Bio] as? String
            user.drives = userData![Response.UserInfo.Drives] as? String
            
            if let urlString = userData![Response.UserInfo.AvatarUrl] as? String {
                user.avatarURL = NSURL(string: urlString)
            }
            
            currUser = user
            currUser?.saveUser()
            completion(user, nil)
            
            APNSManager.sharedManager.registerForRemoteNotifications()
        }
    }
    
    class func logout() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(UserKeys.User)
        currUser = nil
    }
    
    func uploadPhoto(image: UIImage, completion: ((NSURL?, NSError?) -> ())) {
        if let data = UIImagePNGRepresentation(image) {
            RequestManager.sharedInstance().uploadAvatar(data, completion: completion)
        }
    }
}
