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
    
    @IBOutlet var carLabel: UILabel!
    @IBOutlet var goodLabel: UILabel!
    @IBOutlet var jobLabel: UILabel!
    
    @IBOutlet var carConstraint: NSLayoutConstraint!
    @IBOutlet var goodConstraint: NSLayoutConstraint!
    @IBOutlet var jobConstraint: NSLayoutConstraint!
    
    let ConstraintConstant: CGFloat = 12.0
    let SmallFont = UIFont(name: FontNames.Montserrat.Regular, size: 12)
    
    override func viewDidLoad() {
        navigationController?.navigationBar.hidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIScreen.mainScreen().bounds.width <= 360 {
//            carConstraint.constant = ConstraintConstant
//            goodConstraint.constant = ConstraintConstant
//            jobConstraint.constant = ConstraintConstant
            
            carLabel.font = SmallFont
            goodLabel.font = SmallFont
            jobLabel.font = SmallFont
        }
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
        let vc = storyboard?.instantiateViewControllerWithIdentifier(JobOffersVC.StoryBoardID)
        
        if let viewController = vc as? JobOffersVC {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
