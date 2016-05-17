//
//  AddFriendsVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/1/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class AddFriendsVC: UITableViewController {
    @IBOutlet var headerView: UIView!
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var contoctsLabel: UILabel!
    @IBOutlet var fbLabel: UILabel!
    @IBOutlet var instagramLabel: UILabel!
    @IBOutlet var twitterLabel: UILabel!
    
    private var tableHeaderHeight: CGFloat = 226
    private var headerViewSetuper: UITableViewHeaderSetuper?
    
    override func viewDidLoad() {
        headerViewSetuper = UITableViewHeaderSetuper(tableView: tableView, headerHeight: tableHeaderHeight)
        if UIScreen.mainScreen().bounds.width <= 360 {
            setSmallFont()
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        headerViewSetuper?.updateHeaderView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = false
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: Fonts.Login.NavigationTitle,  NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
}

//MARK: - Private Methods
extension AddFriendsVC {
    private func setSmallFont() {
        let font = UIFont(name: FontNames.Montserrat.Regular, size: 15)
        headerLabel.font = UIFont(name: FontNames.Montserrat.Regular, size: 17)
        contoctsLabel.font = font
        fbLabel.font = font
        instagramLabel.font = font
        twitterLabel.font = font
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