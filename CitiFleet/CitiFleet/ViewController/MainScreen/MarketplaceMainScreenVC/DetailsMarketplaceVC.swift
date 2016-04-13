//
//  DetailsMarketplaceVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/2/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class DetailsMarketplaceVC: UITableViewController {
    private let PhotoHeight: CGFloat = 0
    private var DescriptionHeight: CGFloat {
        get {
            return 0
        }
    }
    
    @IBOutlet var priceWidth: NSLayoutConstraint!
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var itemName: UILabel!
    @IBOutlet var itemNameBgView: UIView!
    
    @IBOutlet var itemDescription: UILabel!

    var item: MarketplaceItem! {
        didSet {
            
        }
    }
    var itemInfoHeight: CGFloat {
        get {
            return 43
        }
    }
    
    
}

extension DetailsMarketplaceVC {
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return itemInfoHeight
    }
}