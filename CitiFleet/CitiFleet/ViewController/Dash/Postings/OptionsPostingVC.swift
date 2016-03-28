//
//  OptionsPostingVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/20/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class OptionsPostingVC: UITableViewController {
    var cellHeight: CGFloat!
    var numborOfRows: Int!
    var cellBuilder: MyRentSaleCellBuilder!
    var dataManager = MarketPlaceManager()
    var uploader = RentSazeCreator()
    
    override func viewDidLoad() {
        cellBuilder = MyRentSaleCellBuilder(tableView: tableView, marketPlaceManager: dataManager)
        cellBuilder.postingCreater = uploader
        dataManager.loadData()
    }
}

extension OptionsPostingVC {
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
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