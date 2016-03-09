//
//  DashVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/25/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import CoreImage

class DashVC: UITableViewController {
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var backgroundAvatar: UIImageView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    
    var avatarImage: UIImage? {
        get {
            return avatar.image
        }
        set {
            if var image = newValue {
                let imageSide = Sizes.Image.avatarSize
                image = RBSquareImageTo(image, size: CGSize(width: imageSide, height: imageSide))
                avatar.image = image
                backgroundAvatar.image = UIImageManager().blur(image)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.setDefaultShadow()
        nameLabel.text = User.currentUser()?.fullName
        navigationController?.navigationBar.hidden = true
    }
    
    @IBAction func cameraPressed(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let fabric = CameraFabric(dashVC: self)
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
        avatarImage = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

class CameraFabric: NSObject {
    private var dashVC: DashVC
    init(dashVC: DashVC) {
        self.dashVC = dashVC
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
        pickerController.delegate = self.dashVC
        pickerController.sourceType = sourceType
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.dashVC.presentViewController(pickerController, animated: true, completion: nil)
        }
    }
}