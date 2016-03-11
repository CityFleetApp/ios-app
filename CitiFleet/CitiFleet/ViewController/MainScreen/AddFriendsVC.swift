//
//  AddFriendsVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/1/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class AddFriendsVC: UITableViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = false
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: Fonts.Login.NavigationTitle,  NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
}

//MARK: - Table View
extension AddFriendsVC {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            importContactsAddressBook()
        } else if indexPath.section == 1 {
            socialLogin(indexPath.row)
        }
    }
    
    func importContactsAddressBook() {
        SocialManager.sharedInstance.importContacts()
        
    }
    
    func socialLogin(index: Int) {
        switch index {
        case 0:
            SocialManager.sharedInstance.loginFacebook(self)
            break
        case 1:
            SocialManager.sharedInstance.loginInstagram()
            break
        case 2:
            SocialManager.sharedInstance.loginTwitter()
            break
        default:
            break
        }
    }
}