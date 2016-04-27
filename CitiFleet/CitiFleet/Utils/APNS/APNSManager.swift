
//
//  APNSManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/24/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

/*
 [aps: {
 alert =     {
 action = added;
 id = 147;
 lat = "49.2389396";
 lng = "28.4803312";
 "report_type" = 4;
 };
 }]
 */

import Foundation

class APNSManager: NSObject {
    enum Notification: String {
        case NewMessage = "receive_message"
        case NewJobOffer = "APNS.NewJobOfer"
        case NewNotification = "APNS.NewNotification"
    }
    
    let AlreadyRegisteredKey = "AlreadyRegisteredKey"
    var deviceToken: String?
    private static let _sharedManager = APNSManager()
    static var sharedManager: APNSManager {
        get {
            return _sharedManager
        }
    }
    
    func didReceiveRemoteNotification(userInfo: [NSObject : AnyObject]) {
        print(userInfo)
        
        if let messageObj = userInfo[Notification.NewMessage.rawValue] {
            let message = Message()
            message.message = userInfo[DictionaryKeys.APNS.main]![DictionaryKeys.APNS.alert] as? String
            message.roomId = messageObj[Response.Chat.roomID] as? Int
            let avatarStr = (messageObj[Response.UploadAvatar.avatar] as? String)
            if avatarStr != "" && avatarStr != nil {
                message.author = User()
                message.author?.avatarURL = NSURL(string: avatarStr!)
            }
            let notification = NSNotification(name: Notification.NewMessage.rawValue, object: message)
            NSNotificationCenter.defaultCenter().postNotification(notification)
        }
    }
    
    func registerForRemoteNotifications() {
        let application = UIApplication.sharedApplication()
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
    }
    
    func unregisterForRemoteNotifications() {
        let application = UIApplication.sharedApplication()
        application.unregisterForRemoteNotifications()
    }
    
    func registerAPNSToken(deviceToken: NSData?) {
        if (NSUserDefaults.standardUserDefaults().valueForKey(AlreadyRegisteredKey) as? Bool) == true {
            return
        }
        typealias APNSParams = Params.User.APNS
        
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        let deviceTokenString: String = deviceToken!.description
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        self.deviceToken = deviceTokenString
        
        let params = [
            APNSParams.deviceId: (UIDevice.currentDevice().identifierForVendor?.UUIDString)!,
            APNSParams.registrationId: deviceTokenString
        ]
        if User.currentUser()?.token == nil {
            return 
        }
        RequestManager.sharedInstance().makeSilentRequest(.POST, baseURL: URL.User.APNS.Register, parameters: params) { [weak self] (json, error) -> () in
            if error == nil {
                if let key = self?.AlreadyRegisteredKey {
                    NSUserDefaults.standardUserDefaults().setValue(true, forKey: key)
                }
            }
        }
    }
}
