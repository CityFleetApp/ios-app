//
//  ChatVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/14/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import Haneke

class ChatVC: UIViewController {
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
    @IBOutlet var messageTF: UITextField!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    var datasource = ChatDataSource()
    var room: ChatRoom!
    
    override func viewDidLoad() {
        setupCollectionViewLayouts()
        setupDatasource()
        setupNotifications()
    }
}

//MARK: - Actions
extension ChatVC {
    @IBAction func send(sender: AnyObject) {
        let message = Message()
        message.author = User.currentUser()
        message.message = messageTF.text
        message.roodHash = room.label
        
        SocketManager.sharedManager.sendMessage(message)
        messageTF.resignFirstResponder()
    }
}

//MARK: - Private Methods
extension ChatVC {
    private func setupNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func setupCollectionViewLayouts() {
        let layout = collectionView.collectionViewLayout as! MarketplaceCollectiovViewLayout
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
//            ChatVC.CellPadding * 2
        let height = text.heightWithConstrainedWidth(width, font: font) + ChatVC.StandardPadding * 2
        return max(ChatVC.PhotoWidth, height)
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
        cell.messageDateLbl.text = "\((message.author?.fullName)!) wrote at \(NSDateFormatter.standordFormater().stringFromDate(message.date!))"
        cell.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        return cell
    }
}

//MARK: - Layout Delegate
extension ChatVC: MarketplaceLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return ChatVC.StandardPadding * 2
    }
    
    func collectionView(collectionView: UICollectionView, heightForInfoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let message = datasource.messages[indexPath.item]
        let font = UIFont(name: FontNames.Montserrat.Regular, size: 14.4)
        return calculateHeight(message.message!, font: font!)
    }
    
    func collectionView(collectionView: UICollectionView, heightForDescriptionAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return 0
    }
}

//MARK: - Keyboard Events 
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
}