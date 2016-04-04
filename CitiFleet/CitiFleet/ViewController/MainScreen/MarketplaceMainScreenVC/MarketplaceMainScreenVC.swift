//
//  MarketplaceMainScreenVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/30/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class MarketplaceMainScreenVC: UIViewController {
    let ItemsViewControllerID = "GoodsForSaleVC"
    let CarsViewControllerID = "CarsForRentSale"
    override func viewDidLoad() {
        navigationController?.navigationBar.hidden = false
    }
    
    @IBAction func openCarsForSale(sender: AnyObject) {
//       CarsForRentSale
        let vc = storyboard?.instantiateViewControllerWithIdentifier(CarsViewControllerID)
        
        if let viewController = vc as? CarsForRentSale {
            viewController.reuseIdentifier = "CarsForSaleCell"
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func openGeneralGoods(sender: AnyObject) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier(ItemsViewControllerID)
        
        if let viewController = vc as? GoodsForSaleVC {
            viewController.reuseIdentifier = "GoodsForSaleCell"
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func openJobOffers(sender: AnyObject) {
        
    }
}
