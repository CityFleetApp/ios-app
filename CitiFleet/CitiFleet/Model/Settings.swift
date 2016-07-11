//
//  Settings.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/9/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class Settings: NSObject, NSCoding {
    static let notificationsEnabled = "notifications_enabled"
    static let chatPrivacy = "chat_privacy"
    static let visible = "visible"
    
    // MARK: - Keys
    private struct SettingsKeys {
        static let Settings = "Settings"
        static let Brightness = "brightness"
        static let Visible = "Visible"
        static let Notifications = "Notifications"
        static let ChatPrivacy = "ChatPrivacy"
    }
    
    // MARK: - Properties
    var brightness = UIScreen.mainScreen().brightness {
        didSet {
            UIScreen.mainScreen().brightness = brightness
        }
    }
    var visible = false
    var notifications = true
    var chatPrivacy = false
    
    // MARK: - Shared Settings
    static private var _sharedSettings: Settings?
    static var sharedSettings: Settings {
        if let settings = _sharedSettings {
            return settings
        }
        
        let settingsData = NSUserDefaults.standardUserDefaults().objectForKey(SettingsKeys.Settings) as? NSData
        if let data = settingsData {
            _sharedSettings = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Settings
        }
        
        if let settings = _sharedSettings {
            return settings
        } else {
            _sharedSettings = Settings()
            let data = NSKeyedArchiver.archivedDataWithRootObject(_sharedSettings!)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: SettingsKeys.Settings)
        }
        
        return _sharedSettings!
    }
    
    // MARK: - Constructor
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        if let brightnessVal = aDecoder.decodeObjectForKey(SettingsKeys.Brightness) as? CGFloat {
            brightness = brightnessVal
        }
        if let visibleVal = aDecoder.decodeObjectForKey(SettingsKeys.Visible) as? Bool {
            visible = visibleVal
        }
        if let notificationsVal = aDecoder.decodeObjectForKey(SettingsKeys.Notifications) as? Bool {
            notifications = notificationsVal
        }
        if let chatPrivacyVal = aDecoder.decodeObjectForKey(SettingsKeys.ChatPrivacy) as? Bool {
            chatPrivacy = chatPrivacyVal
        }
    }
    
    func saveSettings() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: SettingsKeys.Settings)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        let objects = [
            SettingsKeys.Brightness: brightness,
            SettingsKeys.Visible: visible,
            SettingsKeys.Notifications: notifications,
            SettingsKeys.ChatPrivacy: chatPrivacy
        ]
        
        for field in objects {
            aCoder.encodeObject(field.1, forKey: field.0 as! String)
        }
    }
    
    func applySettings() {
        UIScreen.mainScreen().brightness = self.brightness
    }
    
    func loadSettings(completion: (() -> ())) {
        RequestManager.sharedInstance().get(URL.User.Settings, parameters: nil) { [unowned self] (json, error) in
            guard let json = json?.dictionaryObject else {
                completion()
                return
            }
            
            if let visible = json[Settings.visible] as? Bool {
                self.visible = visible
            }
            
            if let notification = json[Settings.notificationsEnabled] as? Bool {
                self.notifications = notification
            }
            
            if let chat = json[Settings.notificationsEnabled] as? Bool {
                self.chatPrivacy = chat
            }
            
            self.saveSettings()
            completion()
        }
    }
    
    func patch(param: String, enabled: Bool, completion: (() -> ())) {
        let params = [
            param: enabled
        ]
        RequestManager.sharedInstance().patch(URL.User.Settings, parameters: params) { (_, _) in
            completion()
        }
    }
    
    func patchNotification(enabled: Bool, completion: (() -> ())) {
        patch(Settings.notificationsEnabled, enabled: enabled, completion: completion)
    }
    
    func patchChat(enabled: Bool, completion: (() -> ())) {
        patch(Settings.chatPrivacy, enabled: enabled, completion: completion)
    }
    
    func patchVisible(enabled: Bool, completion: (() -> ())) {
        patch(Settings.visible, enabled: enabled, completion: completion)
    }
}
