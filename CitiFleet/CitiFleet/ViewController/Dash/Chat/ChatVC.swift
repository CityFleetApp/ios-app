//
//  ChatVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/14/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import Haneke
import KMPlaceholderTextView
import AVFoundation

class ChatVC: UIViewController {
    private static let StoryBoardID = "ChatVC"
    private let MessageButtonSide: CGFloat = 58
    
    static let MessagePadding: CGFloat = 16
    static let MessageMarging: CGFloat = 16
    static let PhotoLeftPadding: CGFloat = 25
    static let PhotoRightPadding: CGFloat = 16
    static let PhotoWidth: CGFloat = 70
    static let CellPadding: CGFloat = 5
    static let StandardPadding: CGFloat = 16
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var messageView: UIView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTF: UITextView!
    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var messageViewHeight: NSLayoutConstraint!
    
    var datasource: ChatDataSource!
    var room: ChatRoom! {
        didSet {
            datasource = ChatDataSource(room: room)
            setupDatasource()
        }
    }
    
    class func viewControllerFromStoryboard() -> ChatVC {
        let storyboard = UIStoryboard(name: Storyboard.Chat, bundle: nil)
        if let viewController = storyboard.instantiateViewControllerWithIdentifier(ChatVC.StoryBoardID) as? ChatVC {
            return viewController
        } else {
            return ChatVC()
        }
    }
    
    override func openMessage(notification: NSNotification) {
        if let message = notification.object as? Message {
            if message.roomId != room.id {
                super.openMessage(notification)
            }
        }
    }
    
    override func viewDidLoad() {
        setupCollectionViewLayouts()
        setupNotifications()
        SocketManager.sharedManager.open()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        messageTF.placeholder = Titles.Chat.TextViewPlaceHolder
        messageTF.placeholderColor = UIColor.whiteColor()
        navigationController?.navigationBar.hidden = false 
    }
}

//MARK: - Actions
extension ChatVC {
    @IBAction func send(sender: AnyObject) {
        if messageTF.text != nil && messageTF.text != "" {
            let message = Message()
            message.author = User.currentUser()
            message.message = messageTF.text
            message.roomId = room.id
            message.date = NSDate()
            
            SocketManager.sharedManager.sendMessage(message)
            messageTF.resignFirstResponder()
            messageTF.text = ""
            textViewDidChange(messageTF)
        }
    }
    
    @IBAction func sendPhoto(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let fabric = CameraFabric(imagePicerDelegate: self)
        alert.addAction(fabric.cameraAction())
        alert.addAction(fabric.libraryAction())
        alert.addAction(fabric.cancelAction())
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func addRoom(sender: AnyObject) {
        if let vc = storyboard?.instantiateViewControllerWithIdentifier(ContactListVC.StoryboardID) as? ContactListVC {
            let navigationController = UINavigationController()
            navigationController.viewControllers = [vc]
            presentViewController(navigationController, animated: true, completion: nil)
            vc.selectionCompleted = { [weak self] (users) in
                if let users = users {
                    RequestManager.sharedInstance().patchRoom((self?.room)!, participants: users, completion: { (room, error) in
                        
                    })
                }
            }
        }
    }
}

//MARK: - Private Methods
extension ChatVC {
    private func setupNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(receivedNewMessage(_:)), name: SocketManager.NewMessage, object: nil)
    }
    
    private func setupCollectionViewLayouts() {
        let layout = collectionView.collectionViewLayout as! ChatCollectiovViewLayout
        layout.cellPadding = ChatVC.CellPadding
        layout.delegate = self
        layout.numberOfColumns = 1
        
        collectionView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
    }
    
    private func setupDatasource() {
        datasource.reloadData = { [weak self] in
            self?.collectionView.reloadData()
        }
        datasource.loadData()
    }
    
    private func calculateHeight(text: String, font: UIFont) -> CGFloat {
        let layout = collectionView.collectionViewLayout as! MarketplaceCollectiovViewLayout
        let width = layout.columnWidth -
            ChatVC.MessagePadding -
            ChatVC.MessageMarging -
            ChatVC.PhotoLeftPadding -
            ChatVC.PhotoRightPadding -
            ChatVC.PhotoWidth - ChatVC.StandardPadding * 2

        let height = text.heightWithConstrainedWidth(width, font: font) + ChatVC.StandardPadding * 2
        return max(ChatVC.PhotoWidth, height)
    }
    
    private func calculateImageSize(size: CGSize) -> CGFloat {
        let layout = collectionView.collectionViewLayout as! MarketplaceCollectiovViewLayout
        let width = layout.columnWidth -
            ChatVC.MessagePadding -
            ChatVC.MessageMarging -
            ChatVC.PhotoLeftPadding -
            ChatVC.PhotoRightPadding -
            ChatVC.PhotoWidth - ChatVC.StandardPadding * 2
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRectWithAspectRatioInsideRect(size, boundingRect)
        return max(ChatVC.PhotoWidth, rect.height)
    }
    
    private func calculateHeightForMessage() -> CGFloat {
        let topSize: CGFloat = 32 + messageTF.contentInset.bottom * messageTF.contentInset.top
        let textViewWidth = CGRectGetWidth(UIScreen.mainScreen().bounds) - MessageButtonSide * 2
        let height = messageTF.attributedText.heightWithConstrainedWidth(textViewWidth) + topSize + messageTF.contentInset.left + messageTF.contentInset.right
        return max(height, MessageButtonSide)
    }
}

//MARK: - Collection View Delegate
extension ChatVC: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.messages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let message = datasource.messages[indexPath.item]
        let CellID = message.author == User.currentUser() ? ChatCollectionViewCell.MyMessageCellID : ChatCollectionViewCell.OtherMessageCellID
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellID, forIndexPath: indexPath) as! ChatCollectionViewCell
        cell.avatarImageView.image = UIImage(named: Resources.NoAvatarIc)
        if let url = message.author?.avatarURL {
            cell.avatarImageView.hnk_setImageFromURL(url)
        }
        cell.messageLbl.text = message.message
        cell.messageDateLbl.text = "\((message.author?.fullName)!) wrote at \(NSDateFormatter(dateFormat: "MM/dd/yyyy HH:mm").stringFromDate(message.date!))"
        
        if message.imageURL != nil {
            cell.messageImage.image = nil
            cell.messageLbl.hidden = true
            cell.messageImage.hidden = false
            message.getImage({ (image) in
                cell.messageImage.image = image
            })
        } else {
            cell.messageLbl.hidden = false
            cell.messageImage.hidden = true
            cell.messageImage.image = nil
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let message = datasource.messages[indexPath.item]
        if let url = message.imageURL {
            message.getImage({ (image) in
                let galleryPhoto = GalleryPhoto(image: image, imageData: nil, attributedCaptionTitle: NSAttributedString(), largePhotoURL: url, thumbURL: url, id: nil)
                let photosViewController = FriendGalleryVC(photos: [galleryPhoto], initialPhoto: galleryPhoto)
                AppDelegate.sharedDelegate().rootViewController().presentViewController(photosViewController, animated: true, completion: nil)
            })
        }
    }
}

extension ChatVC: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == datasource.messages.count - 1 {
            datasource.loadNew({ [weak self] (messages) in
                if messages == nil {
                    return
                }
                var indexPathes: [NSIndexPath] = []
                for index in (indexPath.row + 1)...(indexPath.row + messages!.count) {
                    indexPathes.append(NSIndexPath(forRow: index, inSection: 0))
                }
                self?.collectionView.insertItemsAtIndexPaths(indexPathes)
            })
        }
    }
}

//MARK: - Layout Delegate
extension ChatVC: MarketplaceLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return ChatVC.StandardPadding * 3
    }
    
    func collectionView(collectionView: UICollectionView, heightForInfoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let message = datasource.messages[indexPath.item]
        
        if let size = message.imageSize {
            return calculateImageSize(size)
        }
        
        let font = UIFont(name: FontNames.Montserrat.Regular, size: 14.4)
        return calculateHeight(message.message!, font: font!)
    }
    
    func collectionView(collectionView: UICollectionView, heightForDescriptionAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return 0
    }
}

//MARK: - TextView Delegate
extension ChatVC: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        messageViewHeight.constant = max(textView.contentSize.height + 32, MessageButtonSide)
        view.layoutIfNeeded()
    }
}

//MARK: - Notification Events
extension ChatVC {
    func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue().height
        bottomConstraint.constant = keyboardHeight!
        UIView.animateWithDuration(0.25) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 0
        UIView.animateWithDuration(0.25) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func receivedNewMessage(notification: NSNotification) {
        if let message = notification.object as? Message {
            if message.roomId == room.id {
                datasource.messages.insert(message, atIndex: 0)
                let indexPath = NSIndexPath(forItem: 0, inSection: 0)
                let pathes:[NSIndexPath] = [indexPath]
                
                collectionView.insertItemsAtIndexPaths(pathes)
            }
        }
    }
}

extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true) { [weak self] in
            let message = Message()
            message.author = User.currentUser()
            message.roomId = self?.room.id
            message.date = NSDate()
            message.image = image.scaleToMaxSide(Sizes.Image.upladeSide)
            
            SocketManager.sharedManager.sendMessage(message)
        }
    }
}