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
    var uploader = RentSazeCreator()
    
    private var vehicleCollectionViewDelegate: VehicleCollectionViewDelegate!
    
    override func viewDidLoad() {
        cellBuilder = MyRentSaleCellBuilder(tableView: tableView, marketPlaceManager: dataManager)
        cellBuilder.postingCreater = uploader
        dataManager.loadData()
        
        vehicleCollectionViewDelegate = VehicleCollectionViewDelegate(reloadData: { [unowned self] in
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