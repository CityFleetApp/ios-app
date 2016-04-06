//
//  DashVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/25/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import CoreImage
import Haneke

class DashVC: UITableViewController {
    @IBOutlet var headerView: AvatarCameraView!
    private var tableHeaderHeight: CGFloat = 235
    private var headerViewSetuper: UITableViewHeaderSetuper?
    override func viewDidLoad() {
        super.viewDidLoad()
        headerViewSetuper = UITableViewHeaderSetuper(tableView: tableView, headerHeight: tableHeaderHeight)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        preloadData()
        navigationController?.navigationBar.hidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueID.Dash2Profile {
            let profileVC = segue.destinationViewController as! ProfileVC
            profileVC.user = User.currentUser()
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        headerViewSetuper?.updateHeaderView()
    }
    
    func preloadData() {
        headerView.nameLabel.text = User.currentUser()?.fullName
        headerView.cameraAction = cameraPressed
        if let URL = User.currentUser()?.avatarURL {
            headerView.avatarUrl = URL
        }
    }
    
    @IBAction func cameraPressed(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let fabric = CameraFabric(imagePicerDelegate: self)
        alert.addAction(fabric.cameraAction())
        alert.addAction(fabric.libraryAction())
        alert.addAction(fabric.cancelAction())
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

//MARK: - Menu events
extension DashVC {
    func home() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logOut() {
        dismissViewControllerAnimated(true) {
            User.logout()
            AppDelegate.sharedDelegate().showLoginViewController()
        }
    }
}

extension DashVC {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            home()
            break
        case 8:
            navigationController?.pushViewController(HelpVC(), animated: true)
            break
        case 10:
            logOut()
            break
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.setZeroSeparator(cell)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.bounds), height: 22))
        view.backgroundColor = UIColor.blackColor()
        return view
    }
}

extension DashVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        let imageSide = Sizes.Image.avatarSize
        let scaledImage = RBSquareImageTo(image, size: CGSize(width: imageSide, height: imageSide))
        picker.dismissViewControllerAnimated(true) {
            User.currentUser()?.uploadPhoto(scaledImage, completion: self.handleUploadingProcess)
        }
    }
    
    func handleUploadingProcess(URL: NSURL?, error: NSError?) {
        if let _ = error {
            return
        }
        
        headerView.avatarUrl = URL
    }
}

class CameraFabric: NSObject {
    private var imagePicerDelegate: protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
    init(imagePicerDelegate: protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>) {
        self.imagePicerDelegate = imagePicerDelegate
        super.init()
    }
    
    func cameraAction() -> UIAlertAction {
        return UIAlertAction(title: Titles.Dash.openCamera, style: UIAlertActionStyle.Default) { (action) -> Void in
            self.showPicker(.Camera)
        }
    }
    
    func libraryAction() -> UIAlertAction {
        return UIAlertAction(title: Titles.Dash.openLibrary, style: UIAlertActionStyle.Default) { (action) -> Void in
            self.showPicker(.PhotoLibrary)
        }
    }
    
    func cancelAction() -> UIAlertAction {
        return UIAlertAction(title: Titles.cancel, style: .Cancel, handler: nil)
    }
    
    func showPicker(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self.imagePicerDelegate
        pickerController.sourceType = sourceType
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            AppDelegate.sharedDelegate().rootViewController().presentViewController(pickerController, animated: true, completion: nil)
        }
    }
}