//
//  MainScreenVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/25/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class RootVC: UIViewController {
    override func subscribeNotifications() {
        
    }
    
    override func unsubscribe() {
        
    }
}

class MainScreenVC: UIViewController {
    private let ReportInfoViewHeght: CGFloat = 150
    
    @IBOutlet var dashboardBtn: UIButton!
    @IBOutlet var marketPlaceBtn: UIButton!
    @IBOutlet var notificationsBtn: UIButton!
    @IBOutlet var reportBtn: UIButton!
    
    @IBOutlet var burgerBtn: UIButton!
    @IBOutlet var addFriendsBtn: UIButton!
    
    private var _reportInfoView: ReportInfoView?
    private var _friendInfoView: FriendInfoView?
    
    private var reportInfoView: ReportInfoView {
        if let infoView = _reportInfoView {
            return infoView
        }
        _reportInfoView = ReportInfoView.viewFromNib()
        _reportInfoView!.frame = CGRect(x: 0, y: -ReportInfoViewHeght, width: UIScreen.mainScreen().bounds.width, height: ReportInfoViewHeght)
        view.addSubview(_reportInfoView!)
        return _reportInfoView!
    }
    
    private var friendInfoView: FriendInfoView {
        if let friendInfoView = _friendInfoView {
            return friendInfoView
        }
        _friendInfoView = FriendInfoView.viewFromNib()
        _friendInfoView?.frame = CGRect(x: 0, y: -ReportInfoViewHeght, width: UIScreen.mainScreen().bounds.width, height: ReportInfoViewHeght)
        view.addSubview(_friendInfoView!)
        
        _friendInfoView?.messageFriend = { [weak self] (friend) in
            let friend = self?._friendInfoView?.friend
            RequestManager.sharedInstance().postRoom([friend!], completion: { (room, error) in
                if error == nil {
                    dispatch_async(dispatch_get_main_queue(), { [weak self] in
                        let vc = ChatVC.viewControllerFromStoryboard()
                        vc.room = room
                        self?.navigationController?.pushViewController(vc, animated: true)
                    })
                }
            })
        }
        
        _friendInfoView?.openFriendProfile = { [weak self] (friend) in
            let profileVC = ProfileVC.viewControllerFromStoryboard()
            profileVC.user = friend
            self?.navigationController?.pushViewController(profileVC, animated: true)
        }
        
        return _friendInfoView!
    }
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mapVC = segue.destinationViewController as? MapVC {
            mapVC.infoDelegate = self
            mapVC.delegate = self
        }
    }
}

//MARK: - Private Methods
extension MainScreenVC {
    private func setCenterImage() {
        let buttons = [dashboardBtn, marketPlaceBtn, notificationsBtn, reportBtn]
        for button in buttons {
            button.setImage(button.imageForState(.Normal)?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
            button.centerImageAndTitle()
        }
    }
    
    private func showReportInfo() {
        UIView.animateWithDuration(0.5) { [weak self] in
            if self == nil {
                return
            }
            self?.reportInfoView.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: (self?.ReportInfoViewHeght)!)
        }
    }
    
    private func hideReportInfo() {
        UIView.animateWithDuration(0.5) { [weak self] in
            if self == nil {
                return
            }
            self?.reportInfoView.frame = CGRect(x: 0, y: -self!.ReportInfoViewHeght, width: UIScreen.mainScreen().bounds.width, height: (self?.ReportInfoViewHeght)!)
        }
    }
}

//MARK: - Actions
extension MainScreenVC {
    @IBAction func updateButtonsColor(selectedButton: UIButton) {
        let buttons = [dashboardBtn, marketPlaceBtn, notificationsBtn, reportBtn]
        for button in buttons {
            let color = button == selectedButton ? UIColor.whiteColor() : UIColor(white: 1, alpha: 0.4)
            button.setTitleColor(color, forState: .Normal)
            button.tintColor = color
        }
    }
    
    @IBAction func openDash(sender: AnyObject) {
        let storyboard = UIStoryboard(name: Storyboard.DashStoryboard, bundle: NSBundle.mainBundle())
        let viewController = storyboard.instantiateViewControllerWithIdentifier(ViewControllerID.Dash)
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func showReportsMenu(sender: AnyObject) {
        ReportsView.reportFromNib().show(onViewController: self)
    }
}

//MARK: - Info Delegate
extension MainScreenVC: InfoViewDelegate {
    func showFrinedInfo(friend: Friend?) {
        friendInfoView.friend = friend
        friendInfoView.showView()
        reportInfoView.hideView()
    }
    
    func showReportInfo(report: Report?) {
        reportInfoView.report = report
        reportInfoView.showView()
        friendInfoView.hideView()
    }
    
    func hideViewes() {
        reportInfoView.hideView()
        friendInfoView.hideView()
    }
}

//MARK: - Map View Delegate
extension MainScreenVC: MapViewDelegate {
    func showReport(coordinate: CLLocationCoordinate2D?) {
        let reportView = ReportsView.reportFromNib()
        reportView.coordinate = coordinate
        reportView.show(onViewController: self)
    }
}

class MapVCContainer: UIViewController {
    
}
