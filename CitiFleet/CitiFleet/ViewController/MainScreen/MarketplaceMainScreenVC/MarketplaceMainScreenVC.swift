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
    override func viewDidLoad() {
        navigationController?.navigationBar.hidden = false
    }
    
    @IBAction func openCarsForSale(sender: AnyObject) {
       
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
