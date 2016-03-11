//
//  Settings.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/9/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class Settings: NSObject, NSCoding {
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
}
