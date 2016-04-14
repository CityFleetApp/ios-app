//
//  ChatRoomCell.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/14/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class ChatRoomCell: UITableViewCell {
    static let ChatRoomCellOnePhotoID = "ChatRoomCellOnePhotoID"
    static let ChatRoomCellTwoPhotoID = "ChatRoomCellTwoPhotoID"
    
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var secondAvatar: UIImageView?
    @IBOutlet weak var roomNameLbl: UILabel!
    @IBOutlet weak var lastMessageLbl: UILabel!
    
    override func awakeFromNib() {
        avatar.layer.borderWidth = 1
        avatar.layer.borderColor = UIColor.whiteColor().CGColor
        
        secondAvatar?.layer.borderWidth = 1
        secondAvatar?.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
}
