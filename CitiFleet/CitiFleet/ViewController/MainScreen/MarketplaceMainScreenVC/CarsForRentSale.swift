//
//  CarsForRentSale.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/1/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import AVFoundation

class CarsForRentSale: GoodsForSaleVC {
    private let ChangedRentSaleValue = "changedRentSale:"
    var isSale = true
    
    override func loadData() {
        if isSale {
            dataLoader.loadCarsForSale({ [unowned self] (error) in
                if error == nil {
                    (self.collectionViewLayout as! MarketplaceCollectiovViewLayout).cache.removeAll()
                    self.collectionView?.reloadData()
                }
                })
        } else {
            dataLoader.loadCarsForRent({ [unowned self] (error) in
                if error == nil {
                    (self.collectionViewLayout as! MarketplaceCollectiovViewLayout).cache.removeAll()
                    self.collectionView?.reloadData()
                }
                })
        }
    }
    
    override func addSubviewToTopView() {
        let segmentContrell = UISegmentedControl(items: ["Buy", "Rent"])
        var segmentFrame = segmentContrell.frame
        let margin = CGFloat(16)
        segmentFrame.size.width = topView.bounds.width - margin * 2
        segmentFrame.origin.x = margin
        segmentFrame.origin.y = (topView.bounds.height - segmentFrame.height) / 2
        
        segmentContrell.frame = segmentFrame
        segmentContrell.tintColor = Color.Global.LightGreen
        segmentContrell.selectedSegmentIndex = 0
        segmentContrell.addTarget(self, action: Selector(ChangedRentSaleValue), forControlEvents: .ValueChanged)
        
        topView.addSubview(segmentContrell)
    }
    
    override func setupAdditionalData(cell: MarketplaceTemplateCell, indexPath: NSIndexPath) {
        let item = dataLoader.items[indexPath.row] as! CarForRentSale
        let cell = cell as! CarsForSaleCell
        cell.itemName.text = "\(item.year!) \(item.make!) \(item.model!)"
        cell.colorLabel.text = item.color
        cell.carTypeLabel.text = item.type
        cell.fuelLabel.text = item.fuel
        cell.seatsLabel.text = String(item.seats!)
    }
    
    override func collectionView(collectionView: UICollectionView, heightForInfoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return 70
    }
}

extension CarsForRentSale {
    func changedRentSale(sender: UISegmentedControl) {
        isSale = sender.selectedSegmentIndex == 0 ? true : false
        loadData()
    }
}