//
//  MarketplaceTemplateCell.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/31/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class MarketplaceTemplateCell: UICollectionViewCell {
    private let DetailsTappedActionName = "detailsTaped:"
    
    @IBOutlet var imageHeight: NSLayoutConstraint!
    @IBOutlet var infoHeight: NSLayoutConstraint!
    @IBOutlet var detailsHeight: NSLayoutConstraint!
    
    @IBOutlet var priceWidth: NSLayoutConstraint!
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var itemPhoto: UIImageView!
    @IBOutlet var itemName: UILabel!
    @IBOutlet var itemNameBgView: UIView!
    
    @IBOutlet var detailsView: UIView!
    @IBOutlet var itemDescription: UILabel!
    
    var detailsGestureRecognizer: UITapGestureRecognizer!
    var isShownDetails: Bool?
    var changedShownDetails: ((Bool) -> ())!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailsGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(DetailsTappedActionName))
        detailsView.addGestureRecognizer(detailsGestureRecognizer)
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        let attributes = layoutAttributes as! MarketplaceLayoutAttributes
        imageHeight.constant = attributes.photoHeight
        infoHeight.constant = attributes.infoHeight
        detailsHeight.constant = attributes.descriptionHeight
    }
    
    func detailsTaped(gesture: UITapGestureRecognizer) {
        let showDetails = isShownDetails == true ? false : true
        isShownDetails = showDetails
        changedShownDetails(showDetails)
    }
}

class CarsForSaleCell: MarketplaceTemplateCell {
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var carTypeLabel: UILabel!
    @IBOutlet var fuelLabel: UILabel!
    @IBOutlet var seatsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class GoodsForSaleCell: MarketplaceTemplateCell {
    @IBOutlet var itemStateLabel: UILabel!
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
    }
}