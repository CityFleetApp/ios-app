//
//  FriendCell.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/13/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    static let CellID = "FriendCell"
    
    @IBOutlet var avatarImg: UIImageView!
    @IBOutlet var fullNameLbl: UILabel!
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet var phoneLbl: UILabel!
}

class SearchCell: UITableViewCell {
    static let CellID = "SearchCell"
    
    @IBOutlet var searchTF: UITextField!
}