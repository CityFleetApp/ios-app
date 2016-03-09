//
//  Settings.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/9/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {
    @IBOutlet var brightness: UISlider!
    @IBOutlet var visible: UISwitch!
    @IBOutlet var notifications: UISwitch!
    @IBOutlet var chatPrivacy: UISwitch!
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = false
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: Fonts.Login.NavigationTitle,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        applySettings()
    }
    
    func applySettings() {
        let settings = Settings.sharedSettings
        brightness.value = Float(settings.brightness)
        visible.on = settings.visible
        notifications.on = settings.notifications
        chatPrivacy.on = settings.chatPrivacy
    }
}

// MARK: - Actions
extension SettingsVC {
    @IBAction func changeBrightness(sender: UISlider) {
        Settings.sharedSettings.brightness = CGFloat(sender.value)
        Settings.sharedSettings.saveSettings()
    }
    
    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func changedVisibleStatus(sender: UISwitch) {
        Settings.sharedSettings.visible = sender.on
        Settings.sharedSettings.saveSettings()
    }
    
    @IBAction func notificatinsChanged(sender: UISwitch) {
        Settings.sharedSettings.notifications = sender.on
        Settings.sharedSettings.saveSettings()
    }
    
    @IBAction func chatPrivacy(sender: UISwitch) {
        Settings.sharedSettings.chatPrivacy = sender.on
        Settings.sharedSettings.saveSettings()
    }
}

//MARK: - Table View Delegate
extension SettingsVC {
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.setZeroSeparator(cell)
    }
}