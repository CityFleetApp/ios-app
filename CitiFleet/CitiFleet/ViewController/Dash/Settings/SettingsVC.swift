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
    @IBOutlet var headerView: UIView!
    
    private var tableHeaderHeight: CGFloat = 69
    private var headerViewSetuper: UITableViewHeaderSetuper?
    
    override func viewDidLoad() {
        headerViewSetuper = UITableViewHeaderSetuper(tableView: tableView, headerHeight: tableHeaderHeight)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = false
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: Fonts.Login.NavigationTitle,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        applySettings()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        headerViewSetuper?.updateHeaderView()
    }
    
    func applySettings() {
        LoaderViewManager.showLoader()
        
        let settings = Settings.sharedSettings
        settings.loadSettings() { [unowned self] in
            self.brightness.value = Float(settings.brightness)
            self.visible.on = settings.visible
            self.notifications.on = settings.notifications
            self.chatPrivacy.on = settings.chatPrivacy
            
            LoaderViewManager.hideLoader()
        }
        
    }
}

// MARK: - TableView Delegate
extension SettingsVC {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 4:
            dismissViewControllerAnimated(true, completion: nil)
            break
        case 6:
            let helpVC = HelpVC()
            helpVC.urlString = "http://citifleet.steelkiwi.com/api/help/"
            helpVC.title = "Help"
            navigationController?.pushViewController(helpVC, animated: true)
            break
        case 7:
            let helpVC = HelpVC()
            helpVC.urlString = "http://citifleet.steelkiwi.com/api/help/"
            helpVC.title = "Privacy Policy"
            navigationController?.pushViewController(helpVC, animated: true)
            break
        case 8:
            let helpVC = HelpVC()
            helpVC.urlString = "http://citifleet.steelkiwi.com/api/help/"
            helpVC.title = "Terms and Conditions"
            navigationController?.pushViewController(helpVC, animated: true)
            break
        default:
            break
        }
    }
}

// MARK: - Actions
extension SettingsVC {
    @IBAction func changeBrightness(sender: UISlider) {
        Settings.sharedSettings.brightness = CGFloat(sender.value)
        Settings.sharedSettings.saveSettings()
    }
    
    @IBAction func changedVisibleStatus(sender: UISwitch) {
        Settings.sharedSettings.visible = sender.on
        Settings.sharedSettings.saveSettings()
        
        LoaderViewManager.showLoader()
        Settings.sharedSettings.patchVisible(sender.on) {
            LoaderViewManager.hideLoader()
        }
    }
    
    @IBAction func notificatinsChanged(sender: UISwitch) {
        Settings.sharedSettings.notifications = sender.on
        Settings.sharedSettings.saveSettings()
        
        LoaderViewManager.showLoader()
        Settings.sharedSettings.patchNotification(sender.on) {
            LoaderViewManager.hideLoader()
        }
    }
    
    @IBAction func chatPrivacy(sender: UISwitch) {
        Settings.sharedSettings.chatPrivacy = sender.on
        Settings.sharedSettings.saveSettings()
        
        LoaderViewManager.showLoader()
        Settings.sharedSettings.patchChat(sender.on) {
            LoaderViewManager.hideLoader()
        }
    }
}

//MARK: - Table View Delegate
extension SettingsVC {
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.setZeroSeparator(cell)
    }
}