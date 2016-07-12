//
//  EditProfileVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/5/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class EditProfileVC: UITableViewController {
    let StandardCellHeight: CGFloat = 78
    @IBOutlet var bioTextView: KMPlaceholderTextView!
    @IBOutlet var phoneNumberTF: UITextField!
    @IBOutlet var usernameTF: UITextField!
    @IBOutlet var carLbl: HighlitableLabel!
    @IBOutlet var avatarView: AvatarCameraView?
    
    private var headerViewSetuper: UITableViewHeaderSetuper?
    private var tableHeaderHeight: CGFloat = 235
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccessoryView(bioTextView)
        headerViewSetuper = UITableViewHeaderSetuper(tableView: tableView, headerHeight: tableHeaderHeight)
        User.currentUser()?.loadProfile({ [weak self] (error) in
            self?.setupData()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        preloadData()
        setupData()
    }
}

extension EditProfileVC {
    @IBAction func save(sender: AnyObject) {
        typealias Param = Params.User.Profile
        let profile = User.currentUser()?.profile
        var params: [String: String] = [:]
        if let un = profile?.username {
            params[Param.username] = un
        }
        
        if let bio = profile?.bio {
            params[Param.bio] = bio
        }
        
        if let phone = profile?.phone {
            params[Param.phone] = phone
        }
        
        if profile?.carMake != nil && profile?.carModel != nil && profile?.carType != nil && profile?.carYear != nil && profile?.carType != nil {
            params[Param.carMake] = "\((profile?.carMake)!)"
            params[Param.carModel] = "\((profile?.carModel)!)"
            params[Param.carType] = "\((profile?.carType)!)"
            params[Param.carYear] = "\((profile?.carYear)!)"
            params[Param.carColor] = "\((profile?.carColor)!)"
        }
        
        RequestManager.sharedInstance().patch(URL.User.Profile.Profile, parameters: params) { [weak self] (json, error) in
            if error == nil {
                self?.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
}

//MARK: Private Methods
extension EditProfileVC {
    private func setupData() {
        let profile = User.currentUser()?.profile
        phoneNumberTF.text = profile?.phone
        bioTextView.text = profile?.bio
        usernameTF.text = profile?.username
        if profile?.carModelDisplay != nil && profile?.carMakeDisplay != nil && profile?.carYear != nil {
            let carYear = profile?.carYear == nil ? "" : "\(profile!.carYear! + 2009) "
            carLbl.highlitedText = "\(carYear)\(profile!.carMakeDisplay!) \(profile!.carModelDisplay!)"
        }
    }
    
    private func createAccessoryView(textView: UIView) -> UIView {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        let barButton = UIBarButtonItem(title: "Done", style: .Done, target: textView, action: #selector(UIResponder.resignFirstResponder))
        toolBar.items = [barButton]
        barButton.tintColor = Color.Global.BlueTextColor
        return toolBar
    }
    
    private func calculateHeightForBio() -> CGFloat {
        let topSize: CGFloat = 44 + 28
        let textViewWidth = CGRectGetWidth(UIScreen.mainScreen().bounds) - 28
        let height = bioTextView.attributedText.heightWithConstrainedWidth(textViewWidth) + topSize
        return height
    }
    
    private func preloadData() {
        avatarView?.nameLabel.text = User.currentUser()?.fullName?.uppercaseString
        avatarView?.action = { [weak self] (sender) in
            self?.cameraPressed(sender)
        }
        if let URL = User.currentUser()?.avatarURL {
            avatarView?.avatarUrl = URL
        }
    }
    
    private func cameraPressed(sender: AnyObject?) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let fabric = CameraFabric(imagePicerDelegate: self)
        alert.addAction(fabric.cameraAction())
        alert.addAction(fabric.libraryAction())
        alert.addAction(fabric.cancelAction())
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func handleUploadingProcess(URL: NSURL?, error: NSError?) {
        if let _ = error {
            return
        }
        
        avatarView?.avatarUrl = URL
    }
}

//MARK: Table View Delegate
extension EditProfileVC {
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return bioTextView.text.characters.count == 0 ? StandardCellHeight : calculateHeightForBio()
        }
        
        return StandardCellHeight
    }
}

//MARK: ScrollView Delegate
extension EditProfileVC {
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        headerViewSetuper?.updateHeaderView()
    }
}

extension EditProfileVC: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        User.currentUser()?.profile.bio = textView.text
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension EditProfileVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTF {
            User.currentUser()?.profile.username = textField.text
        } else if textField == phoneNumberTF {
            User.currentUser()?.profile.phone = textField.text
        }
        textField.resignFirstResponder()
        return true
    }
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        let imageSide = Sizes.Image.avatarSize
        let scaledImage = RBSquareImageTo(image, size: CGSize(width: imageSide, height: imageSide))
        picker.dismissViewControllerAnimated(true) {
            User.currentUser()?.uploadPhoto(scaledImage, completion: { [weak self] (url, error) in
                if let _ = error {
                    return
                }
                
                self?.avatarView?.avatarUrl = url
            })
        }
    }
}