//
//  OptionsPostingVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/20/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class OptionsPostingVC: UITableViewController {
    @IBOutlet var photoCollectionView: UICollectionView!
    var cellHeight: CGFloat!
    var descriptionCellHeight: CGFloat!
    var numborOfRows: Int!
    var cellBuilder: MyRentSaleCellBuilder!
    var dataManager = MarketPlaceManager()
    var uploader = RentSaleCreator()
    
    private var vehicleCollectionViewDelegate: PostingPhotosCollectionDelegate!
    
    override func viewDidLoad() {
        let menuItemDelete = UIMenuItem(title: "Delete", action: Selector("deletePhoto:"))
        //        let menuItemEdit = UIMenuItem(title: "Edit", action: Selector("editPhoto:"))
        UIMenuController.sharedMenuController().menuItems = [menuItemDelete]
        UIMenuController.sharedMenuController().menuVisible = true
        
        cellBuilder = MyRentSaleCellBuilder(tableView: tableView, marketPlaceManager: dataManager)
        cellBuilder.postingCreater = uploader
        dataManager.loadData()
        
        vehicleCollectionViewDelegate = PostingPhotosCollectionDelegate(reloadData: { [unowned self] in
            self.photoCollectionView.reloadData()
        })
        
        photoCollectionView.dataSource = vehicleCollectionViewDelegate
        photoCollectionView.delegate = vehicleCollectionViewDelegate
        
        cellBuilder.reloadData = { [unowned self] in
            self.tableView.reloadData()
        }
        
        cellBuilder.reloadCell = { [unowned self] (newHeight) in
            self.descriptionCellHeight = newHeight
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    private func handleErrorCode(code: Int) -> Bool {
        if code < 0 {
            return true
        }
        
        if code == RentSaleCreator.NoPhotosErrorCode {
            showNoPhotosAlert(Titles.MarketPlace.noPhotos, message: Titles.MarketPlace.noPhotosMsg)
            return false
        }
        
        if code == RentSaleCreator.NoPriceErrorCode {
            showNoPhotosAlert(Titles.MarketPlace.noPrice, message: Titles.MarketPlace.noPriceMsg)
            return false
        }
        
        if code == RentSaleCreator.NoDescriptionErrorCode {
            showNoPhotosAlert(Titles.MarketPlace.noDescription, message: Titles.MarketPlace.noDescriptionMsg)
            return false
        }
        
        let indexPath = NSIndexPath(forRow: code, inSection: 0)
        
        let cellRect = tableView.rectForRowAtIndexPath(indexPath)
        var position: CGFloat!
        
        if cellRect.origin.y > tableView.contentSize.height - tableView.frame.height {
            position = tableView.contentSize.height - tableView.frame.height
        } else {
            position = cellRect.origin.y
        }
        
        UIView.animateWithDuration(0.25,
            animations: { [unowned self] in
                self.tableView.contentOffset = CGPoint(x: 0, y: position)
            }, completion: { [unowned self] (completed) in
                let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? PostingCell
                if let cell = cell {
                    cell.placeHolder?.textColor = UIColor.redColor()
                }
        })
        
        return false
    }
    
    private func showNoPhotosAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelAct = UIAlertAction(title: Titles.cancel, style: .Cancel, handler: nil)
        alert.addAction(cancelAct)
        presentViewController(alert, animated: true, completion: nil)
    }
}

//MARK: - Actions
extension OptionsPostingVC {
    @IBAction func postRentSale() {
        uploader.photos = vehicleCollectionViewDelegate.images.map({ (photo) -> UIImage in
            return photo.image!
        })
        if !handleErrorCode(uploader.checkCorrectParams()) {
            return
        }
        
        uploader.postNewRentSale() { [unowned self] (error) in
            if error == nil {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
}

extension OptionsPostingVC {
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 8 ? descriptionCellHeight : cellHeight
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numborOfRows
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.setZeroSeparator(cell)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cellBuilder.build(indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PostingCell
        cell.select()
    }
}