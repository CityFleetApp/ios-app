//
//  DetailsMarketplaceVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/2/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import Haneke
import MBProgressHUD

class DetailsMarketplaceVC: UITableViewController {
    private let PhotoHeight: CGFloat = 293
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
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var imageContainerView: UIView!
    @IBOutlet var titleContainerView: UIView!
    @IBOutlet var ownerLabel: UILabel!

    var item: MarketplaceItem! {
        didSet {
            pageVCDataSource = PageViewControllerDataSource(item: item)
        }
    }
    
    var pageVCDataSource: PageViewControllerDataSource!
    var itemInfoHeight: CGFloat {
        get {
            return 43
        }
    }
    
    override func viewDidLoad() {
        itemName.text = item.itemName
        priceLabel.text = "$\(item.price!)"
        itemDescription.text = item.itemDescription
        pageVCDataSource.imageContainerView = imageContainerView
        setupLayer()
        setupAditionalData()
        title = item.itemName
        ownerLabel.text = item.owner?.fullName
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if item.photosURLs.count > 1 {
            setupImages()
        } else {
            setupSingleImage()
        }
    }
    
    func setupAditionalData() {
        colorLabel.text = (item as? GoodForSale)?.condition
    }
}

//MARK: - Private Methods
extension DetailsMarketplaceVC {
    private func setupLayer() {
        let gradient = CAGradientLayer()
        var frame = titleContainerView.bounds
        frame.size.width = UIScreen.mainScreen().bounds.width
        gradient.frame = frame
        gradient.colors = [UIColor.clearColor().CGColor, UIColor(white: 0, alpha: 0.7).CGColor]
        titleContainerView.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    private func setupSingleImage() {
        let imageView = UIImageView(frame: imageContainerView.bounds)
        imageView.contentMode = .ScaleAspectFit
        imageContainerView.addSubview(imageView)
        
        if item.photosURLs.count == 0 {
            imageView.image = UIImage(named: Resources.DOCManagement.TemplatePhoto)
        } else {
            imageView.hnk_setImageFromURL(item.photosURLs[0].URL)
        }
    }
    
    private func setupImages() {
        let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController.dataSource = pageVCDataSource
        pageViewController.delegate = pageVCDataSource
        pageViewController.setViewControllers([pageVCDataSource.viewControllerWithIndex(0)], direction: .Forward, animated: false, completion: nil)
        
        addChildViewController(pageViewController)
        pageViewController.view.frame = imageContainerView.bounds
        imageContainerView.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
    }
}

extension DetailsMarketplaceVC {
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return PhotoHeight
        case 1:
            return itemInfoHeight
        case 2:
            return 100
        case 3:
            return 40
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.setZeroSeparator(cell)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3 {
            let profileVC = ProfileVC.viewControllerFromStoryboard()
            profileVC.user = item.owner
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

class PageViewControllerDataSource: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var item: MarketplaceItem
    var imageContainerView: UIView!
    
    init(item: MarketplaceItem) {
        self.item = item
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 5
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 1
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = viewController.view.tag
        let newIndex = index <= 0 ? item.photosURLs.count - 1 : index - 1
        
        return viewControllerWithIndex(newIndex)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = viewController.view.tag
        let newIndex = index >= item.photosURLs.count - 1 ? 0 : index + 1
        
        return viewControllerWithIndex(newIndex)
    }
    
    func viewControllerWithIndex(index: Int) -> UIViewController {
        let vc = UIViewController()
        vc.view.tag = index
        let imageView = UIImageView(frame: imageContainerView.bounds)
        imageView.contentMode = .ScaleAspectFit
        
        MBProgressHUD.showHUDAddedTo(imageView, animated: true)
        Shared.imageCache.fetch(URL: item.photosURLs[index].URL).onSuccess { (image) in
            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = image
                MBProgressHUD.hideHUDForView(imageView, animated: true)
            }
        }
        
        vc.view.frame = imageContainerView.bounds
        vc.view.addSubview(imageView)
        return vc
    }

}

class DetailCarForRentSaleVC: DetailsMarketplaceVC {
    
    @IBOutlet var colorLbl: UILabel!
    @IBOutlet var typeLbl: UILabel!
    @IBOutlet var fuelLbl: UILabel!
    @IBOutlet var seatsLbl: UILabel!
    
    override var itemInfoHeight: CGFloat {
        return 88
    }
    
    override func setupAditionalData() {
        if let car = item as? CarForRentSale {
            colorLbl.text = car.color
            typeLbl.text = car.type
            fuelLbl.text = car.fuel
            if let seats = car.seats {
                seatsLbl.text = "\(seats)"
            }
        }
    }
}