
//
//  APNSManager.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/24/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

/* Report Push
 [aps: {
    alert = {
        action = added;
        id = 147;
        lat = "49.2389396";
        lng = "28.4803312";
        "report_type" = 4;
    };
 }]
 */

/* Job Offer Push
 [aps: {
    alert = "Job Offer Created";
    sound = defauld;
 }, offer_created: {
    id = 57;
 }]
 */

/* rate driver
 {
    "aps": {
        "alert": "Job Offer Created",
        "sound": "defauld"
    },
        "rate_driver": {
        "id": 56,
        "driver_name": "Vasiliy"
    }
 }
 */

import Foundation
import Alamofire
import SwiftyJSON

class APNSManager: NSObject {
    enum Notification: String {
        case NewMessage = "receive_message"
        case NewJobOffer = "offer_created"
        case JobOfferCompleted = "rate_driver"
        case JobOfferAwarded = "offer_awarded"
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
            parseMessage(messageObj, messageText: userInfo[DictionaryKeys.APNS.main]![DictionaryKeys.APNS.alert] as? String)
        } else if let jobObj = userInfo[Notification.NewJobOffer.rawValue] {
            parseNewJob(jobObj, jobTitle: userInfo[DictionaryKeys.APNS.main]![DictionaryKeys.APNS.alert] as? String, isAwarded: false)
        } else if let jobObj = userInfo[Notification.JobOfferAwarded.rawValue] {
            parseNewJob(jobObj, jobTitle: userInfo[DictionaryKeys.APNS.main]![DictionaryKeys.APNS.alert] as? String, isAwarded: true)
        } else if let jobObj = userInfo[Notification.JobOfferCompleted.rawValue] {
            let jobTitle = userInfo[DictionaryKeys.APNS.main]![DictionaryKeys.APNS.alert] as? String
            parseCompletedJob(jobObj, jobTitle: jobTitle)
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
        if (NSUserDefaults.standardUserDefaults().valueForKey(DictionaryKeys.UserDefaultsKeys.AlreadyRegisteredKey) as? Bool) == true {
            return
        }
//        NSUserDefaults.standardUserDefaults().setValue(false, forKey: DictionaryKeys.UserDefaultsKeys.AlreadyRegisteredKey)
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
        
        Alamofire.request(.POST, RequestManager.sharedInstance().url(URL.User.APNS.Register), headers: RequestManager.sharedInstance().header(), parameters: params, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseData{ response in
                let dataString = String(data: response.data!, encoding: NSUTF8StringEncoding)
                print("Response data: \(dataString)")
                
                switch response.result {
                case .Success(_):
                    NSUserDefaults.standardUserDefaults().setValue(true, forKey: DictionaryKeys.UserDefaultsKeys.AlreadyRegisteredKey)
                    break
                case .Failure(_):
                    if let data = response.data {
                        let json = JSON(data: data)
                        let dict = json.dictionaryObject
                        let existingTokenError = "APNSDevice with this Registration ID already exists."
                        
                        if let dict = dict {
                            if let error = dict["registration_id"] as? [String] {
                                if error.count > 0 && error[0] == existingTokenError {
                                    NSUserDefaults.standardUserDefaults().setValue(true, forKey: DictionaryKeys.UserDefaultsKeys.AlreadyRegisteredKey)
                                }
                            }
                        }
                    }
                    break
                }
        }
    }
}

//MARK: - Private Methods
extension APNSManager {
    private func parseMessage(messageObj: AnyObject, messageText: String?) {
        let message = Message()
        message.message = messageText
        message.roomId = messageObj[Response.Chat.roomID] as? Int
        let avatarStr = (messageObj[Response.UploadAvatar.avatar] as? String)
        if avatarStr != "" && avatarStr != nil {
            message.author = User()
            message.author?.avatarURL = NSURL(string: avatarStr!)
        }
        let notification = NSNotification(name: Notification.NewMessage.rawValue, object: message)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
    private func parseNewJob(jobObj: AnyObject, jobTitle: String?, isAwarded:Bool) {
        let job = JobOffer()
        job.jobTitle = jobTitle
        job.id = jobObj[Response.id] as? Int
        
        let notification = NSNotification(name: isAwarded ? Notification.JobOfferAwarded.rawValue : Notification.NewJobOffer.rawValue, object: job)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
    private func parseCompletedJob(jobObj: AnyObject, jobTitle: String?) {
        let job = JobOffer()
        job.jobTitle = jobTitle
        job.id = jobObj[Response.id] as? Int
        job.driverName = jobObj[Response.Marketplace.JobOffers.driverName] as? String
        
        let notification = NSNotification(name: Notification.JobOfferCompleted.rawValue, object: job)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
}