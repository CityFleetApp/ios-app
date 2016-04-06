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
    @IBOutlet var avatarView: AvatarCameraView!
    
    private var headerViewSetuper: UITableViewHeaderSetuper?
    private var tableHeaderHeight: CGFloat = 235
    
    override func viewDidLoad() {
        createAccessoryView(bioTextView)
        usernameTF.inputAccessoryView = nil
        headerViewSetuper = UITableViewHeaderSetuper(tableView: tableView, headerHeight: tableHeaderHeight)
    }
    
    override func viewWillAppear(animated: Bool) {
        preloadData()
    }
}

//MARK: Private Methods
extension EditProfileVC {
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
        avatarView.nameLabel.text = User.currentUser()?.fullName
        avatarView.cameraAction = { [weak self] (sender) in
            self?.cameraPressed(sender)
        }
        if let URL = User.currentUser()?.avatarURL {
            avatarView.avatarUrl = URL
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
        
        avatarView.avatarUrl = URL
    }
}

//MARK: Table View Delegate
extension EditProfileVC {
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section != 0 && indexPath.row != 0 {
            return StandardCellHeight
        }
        
        return bioTextView.text.characters.count == 0 ? StandardCellHeight : calculateHeightForBio()
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
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension EditProfileVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
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
                
                self?.avatarView.avatarUrl = url
            })
        }
    }
}