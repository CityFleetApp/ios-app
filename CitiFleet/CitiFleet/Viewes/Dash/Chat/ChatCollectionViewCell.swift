//
//  ChatCollectionViewCell.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/14/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {
    static let MyMessageCellID = "MyMessageCellID"
    static let OtherMessageCellID = "OtherMessageCellID"
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageLbl: UILabel!
    @IBOutlet var messageDateLbl: UILabel!
    @IBOutlet var messageHeight: NSLayoutConstraint!
    @IBOutlet var messageImage: UIImageView!
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        guard let attributes = layoutAttributes as? MarketplaceLayoutAttributes else { return }
        messageHeight.constant = attributes.infoHeight
//        self.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
    }
    
}
