//
//  MainScreenVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/25/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class MainScreenVC: UIViewController {
    @IBOutlet var dashboardBtn: UIButton!
    @IBOutlet var marketPlaceBtn: UIButton!
    @IBOutlet var notificationsBtn: UIButton!
    @IBOutlet var reportBtn: UIButton!
    
    @IBOutlet var burgerBtn: UIButton!
    @IBOutlet var addFriendsBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCenterImage()
        
        burgerBtn.setDefaultShadow()
        addFriendsBtn.setDefaultShadow()
        updateButtonsColor(dashboardBtn)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = true
    }
    
    private func setCenterImage() {
        let buttons = [dashboardBtn, marketPlaceBtn, notificationsBtn, reportBtn]
        for button in buttons {
            button.setImage(button.imageForState(.Normal)?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
            button.centerImageAndTitle()
        }
    }
    
    private func updateButtonsColor(selectedButton: UIButton) {
        let buttons = [dashboardBtn, marketPlaceBtn, notificationsBtn, reportBtn]
        for button in buttons {
            let color = button == selectedButton ? UIColor.whiteColor() : UIColor(white: 1, alpha: 0.4)
            button.setTitleColor(color, forState: .Normal)
            button.tintColor = color
        }
    }
}

//MARK: - Actions
extension MainScreenVC {
    @IBAction func openDash(sender: AnyObject) {
        let storyboard = UIStoryboard(name: Storyboard.DashStoryboard, bundle: NSBundle.mainBundle())
        let viewController = storyboard.instantiateViewControllerWithIdentifier(ViewControllerID.Dash)
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func showReportsMenu(sender: AnyObject) {
        ReportsView.reportFromNib().show(onViewController: self)
    }
}
