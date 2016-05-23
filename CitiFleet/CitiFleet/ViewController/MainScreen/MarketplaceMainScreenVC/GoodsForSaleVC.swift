//
//  GoodsForSaleVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/31/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import AVFoundation
import Haneke

class GoodsForSaleVC: UICollectionViewController, MarketplaceLayoutDelegate {
    var reuseIdentifier: String!
    var dataLoader = MarketPlaceShopManager()
    var topView: UIView!
    var titleView: UIView?
    
    lazy var searchItem: UIBarButtonItem = { [weak self] in
        let item = UIBarButtonItem(image: UIImage(named: "search"), style: .Plain, target: self, action: #selector(searchAction(_:)))
        item.tintColor = UIColor.whiteColor()
        return item
    }()
    
    override func viewDidLoad() {
        collectionView!.contentInset = UIEdgeInsets(top: 15 + 66, left: 5, bottom: 10, right: 5)
        
        let layout = collectionViewLayout as! MarketplaceCollectiovViewLayout
        layout.cellPadding = 5
        layout.delegate = self
        layout.numberOfColumns = 2
        
        loadData()
        
        topView = addTopView()
        addSubviewToTopView()
        
        navigationItem.rightBarButtonItems?.append(searchItem)
        
        titleView = navigationItem.titleView
    }
    
    override func viewWillAppear(animated: Bool) {
        topView.hidden = false 
    }
    
    override func viewWillDisappear(animated: Bool) {
        topView.hidden = true
    }
    
    deinit {
        topView.removeFromSuperview()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? DetailsMarketplaceVC {
            let item = dataLoader.items[(collectionView?.indexPathsForSelectedItems()![0].item)!]
            viewController.item = item
        }
    }
    
    override func popToRoot(sender: AnyObject) {
        if navigationItem.titleView?.isKindOfClass(UITextField) == true {
            navigationItem.titleView = titleView
            
            navigationItem.rightBarButtonItems?.append(searchItem)
            
            dataLoader.reload({ [weak self] in
                self?.reloadData()
            })
        } else {
            super.popToRoot(sender)
        }
    }
    
    func reloadData() {
        dataLoader.loadGoodsForSale { [weak self] (error) in
            if error != nil || self == nil {
                return
            }
            
            if let layout = self?.collectionView?.collectionViewLayout as? MarketplaceCollectiovViewLayout {
                layout.cache.removeAll()
            }
            
            self?.collectionView?.reloadData()
        }
    }
    
    func loadData ()  {
        let startCount = dataLoader.items.count
        dataLoader.loadGoodsForSale { [weak self] (error) -> () in
            if error != nil || self == nil{
                return
            }
            let endCount = self?.dataLoader.items.count
            if endCount! - startCount <= 0 {
                return
            }
            
            var indexPathes: [NSIndexPath] = []
            for index in startCount...endCount!-1 {
                indexPathes.append(NSIndexPath(forItem: index, inSection: 0))
            }
            
            self?.collectionView?.insertItemsAtIndexPaths(indexPathes)
        }
    }
    
    func addTopView () -> UIView {
        let navController = self.navigationController
        var navBarFrame = navigationController?.navigationBar.frame
        let imageView = UIImageView(image: UIImage(named: Resources.Marketplace.TopImage))
        navBarFrame?.origin.y = CGRectGetMaxY(navBarFrame!)
        navBarFrame?.size.height = 66
        imageView.frame = navBarFrame!
        navController?.view.addSubview(imageView)
        imageView.userInteractionEnabled = true 
        return imageView
    }
    
    func addSubviewToTopView() {
        let label = UILabel(frame: topView.bounds)
        label.font = UIFont(name: FontNames.Montserrat.Regular, size: 16.59)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.text = Titles.MarketPlace.topLabelTitle
        topView.addSubview(label)
    }
    
    func setupAdditionalData(cell: MarketplaceTemplateCell, indexPath: NSIndexPath) {
        let goodsCell = cell as! GoodsForSaleCell
        let item = dataLoader.items[indexPath.row] as! GoodForSale
        goodsCell.itemStateLabel.text = item.condition
        goodsCell.itemName.text = item.goodName
    }
    
    //MARK: Marketplace Layout Delegate
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let photoSize = dataLoader.items[indexPath.row].photoSize
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRectWithAspectRatioInsideRect(photoSize, boundingRect)
        return rect.height
    }
    
    func collectionView(collectionView: UICollectionView, heightForInfoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return 43
    }
    
    func collectionView(collectionView: UICollectionView, heightForDescriptionAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let StandardHeightForDetails: CGFloat = 26
        
        let item = dataLoader.items[indexPath.row]
        let details = item.itemDescription
        let layout = collectionViewLayout as! MarketplaceCollectiovViewLayout
        let columnWidth = layout.columnWidth
        
        let font = UIFont(name: FontNames.Montserrat.Light, size: 8)
        if let height = details?.heightWithConstrainedWidth(columnWidth, font: font!) {
            return StandardHeightForDetails + (16 + height) * (item.isShownDetails ? 1 : 0)
        } else {
            return StandardHeightForDetails
        }
    }
}

//MARK: - Actions
extension GoodsForSaleVC {
    @IBAction func searchAction(sender: AnyObject?) {
        let searchField = UITextField(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width - 100, height: 26))
        searchField.backgroundColor = UIColor.whiteColor()
        searchField.cornerRadius = 5
        searchField.returnKeyType = .Search
        searchField.becomeFirstResponder()
        searchField.clearButtonMode = .WhileEditing
        searchField.delegate = self
        
        navigationItem.titleView = searchField
        var items = navigationItem.rightBarButtonItems
        items?.removeLast()
        navigationItem.rightBarButtonItems = items
    }
}

extension GoodsForSaleVC {
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataLoader.items.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MarketplaceTemplateCell
        let item = dataLoader.items[indexPath.row]
        cell.priceLabel.text = "$\(item.price!)"
        cell.itemDescription.text = item.itemDescription
        cell.setDefaultShadow()
        
        cell.changedShownDetails = { (shaw) in
            item.isShownDetails = !item.isShownDetails
            collectionView.reloadItemsAtIndexPaths([indexPath])
        }
        
        setupAdditionalData(cell, indexPath: indexPath)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let item = dataLoader.items[indexPath.row]
        let cell = cell as! MarketplaceTemplateCell
        cell.itemPhoto.image = nil
        if item.photosURLs.count > 0 {
            cell.itemPhoto.hnk_setImageFromURL(item.photosURLs[0].URL)
        } else {
            cell.itemPhoto.image = UIImage(named: "default_image_tumb")
        }
        
        let gradient = CAGradientLayer()
        var frame = cell.itemNameBgView.bounds
        frame.size.width = (collectionViewLayout as! MarketplaceCollectiovViewLayout).columnWidth
        gradient.frame = frame
        gradient.colors = [UIColor.clearColor().CGColor, UIColor(white: 0, alpha: 0.7).CGColor]
        for gr in cell.itemNameBgView.layer.sublayers! {
            if gr.isKindOfClass(CAGradientLayer) {
                gr.removeFromSuperlayer()
            }
        }
        cell.itemNameBgView.layer.insertSublayer(gradient, atIndex: 0)
        
        if indexPath.item == dataLoader.items.count - 1 && dataLoader.shouldLoad {
            self.loadData()
        }
    }
}

extension GoodsForSaleVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        dataLoader.reload { [weak self] in
            self?.dataLoader.searchText = textField.text
            self?.reloadData()
        }
        return true
    }
}