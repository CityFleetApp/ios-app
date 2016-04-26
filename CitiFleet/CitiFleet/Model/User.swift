//
//  User.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/24/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation
import AFNetworking

//MARK: Override Operatiors
func ==(left: User?, right: User?) -> Bool {
    return left?.id == right?.id
}

func !=(left: User?, right: User?) -> Bool {
    return left?.id != right?.id
}

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
        static let id = "id"
        static let User = "User"
        static let UserName = "UserName"
        static let FullName = "FullName"
        static let HackLicense = "HackLicense"
        static let Phone = "Phone"
        static let Email = "Email"
        static let Token = "Token"
        static let AvatarURL = "AvatarURL"
    }
    
    var id: Int?
    var fullName: String?
    var hackLicense: String?
    var email: String?
    var token: String?
    var avatarURL: NSURL?
    var rating: Float?
    var documentsUpToDate: Bool? = false
    var jobsCompleted: Int? = 0
    
    var userName: String? {
        return profile.username
    }
    var phone: String? {
        return profile.phone
    }
    var bio: String? {
        return profile.bio
    }
    var drives: String?
    
    var profile = Profile()
    
    private static var currUser: User?
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        id = aDecoder.decodeObjectForKey(UserKeys.id) as? Int
        profile.username = aDecoder.decodeObjectForKey(UserKeys.UserName) as? String
        fullName = aDecoder.decodeObjectForKey(UserKeys.FullName) as? String
        hackLicense = aDecoder.decodeObjectForKey(UserKeys.HackLicense) as? String
        profile.phone = aDecoder.decodeObjectForKey(UserKeys.Phone) as? String
        email = aDecoder.decodeObjectForKey(UserKeys.Email) as? String
        token = aDecoder.decodeObjectForKey (UserKeys.Token) as? String
        if let urlString = aDecoder.decodeObjectForKey(UserKeys.AvatarURL) as? String {
            avatarURL = NSURL(string: urlString)
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        let objects: [String: AnyObject?] = [
            UserKeys.id: id, //!= nil ? String(id!) : "",
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
    
    func loadInfo(completion: ((NSError?) -> ())) {
        typealias Param = Response.UserInfo.Info
        RequestManager.sharedInstance().get(URL.User.Info, parameters: nil) { [weak self] (json, error) in
            if error != nil {
                completion(error)
                return
            }
            
            if let responseDictionory = json?.dictionaryObject {
                if let newAvatar = responseDictionory[Param.avatarURL] as? String {
                    self?.avatarURL = NSURL(string: newAvatar)
                }
                
                self?.drives = responseDictionory[Param.drives] as? String
                self?.profile.bio = responseDictionory[Param.bio] as? String
                self?.rating = responseDictionory[Param.rating] as? Float
                self?.documentsUpToDate = responseDictionory[Param.documentsUpToDate] as? Bool
                self?.jobsCompleted = responseDictionory[Param.jobsCompleted] as? Int 
            }
            completion(nil)
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
                user.profile.username = username
                user.fullName = fullName
                user.hackLicense = hackLicense
                user.profile.phone = phone
                user.email = email
                currUser = user
                currUser?.saveUser()
                completion(user, nil)
                
                APNSManager.sharedManager.registerForRemoteNotifications()
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
            user.id = userData![Params.id] as? Int
            user.token = userData![Response.UserInfo.Token] as? String
            user.email = userData![Response.UserInfo.Email] as? String
            user.profile.username = userData![Response.UserInfo.Username] as? String
            user.fullName = userData![Response.UserInfo.FullName] as? String
            user.hackLicense = userData![Response.UserInfo.HackLicense] as? String
            user.profile.phone = userData![Response.UserInfo.Phone] as? String
            user.profile.bio = userData![Response.UserInfo.Bio] as? String
//            user.profile.drives = userData![Response.UserInfo.Drives] as? String
            
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
        APNSManager.sharedManager.unregisterForRemoteNotifications()
        NSUserDefaults.standardUserDefaults().removeObjectForKey(UserKeys.User)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(APNSManager.sharedManager.AlreadyRegisteredKey)
        currUser = nil
    }
    
    func uploadPhoto(image: UIImage, completion: ((NSURL?, NSError?) -> ())) {
        if let data = UIImagePNGRepresentation(image) {
            RequestManager.sharedInstance().uploadAvatar(data, completion: completion)
        }
    }
}

class Friend: User {
    private static let IconName = "Friend_ic"
    private var _marker: FriendMarker?
    
    var location: CLLocationCoordinate2D!
    
    var marker: FriendMarker {
        if let marker = _marker {
            return marker
        }
        _marker = FriendMarker(position: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        let view = FriendsMarkerView.viewFromNib()
        view.name = fullName
        _marker?.icon = view.imageFromView()
        _marker?.title = userName
        
        _marker?.friend = self
        return _marker!
    }
    
    init(json: AnyObject) {
        super.init()
        id = json[Params.id] as? Int
        avatarURL = NSURL(string: (json[Response.UserInfo.AvatarUrl] as! String))
        fullName = json[Response.UserInfo.FullName] as? String
        email = json[Response.UserInfo.Email] as? String
        profile.username = json[Response.UserInfo.Username] as? String
        profile.phone = json[Response.UserInfo.Phone] as? String
        let lat = json[Response.UserInfo.Latitude] as? Double
        let lng = json[Response.UserInfo.Longitude] as? Double
        
        if lat != nil && lng != nil {
            location = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}