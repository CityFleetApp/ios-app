//
//  MySaleRentVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/19/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class MySaleRentVC: UITableViewController {
    static let CellId = "MyRentSaeCell"
    static let CellHeight: CGFloat = 78
}

//MARK: TableView DataSource
extension MySaleRentVC {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(MySaleRentVC.CellId) as? MyRentSaeCell
        if cell == nil {
            cell = MyRentSaeCell(style: .Default, reuseIdentifier: MySaleRentVC.CellId)
        }
        cell?.type = MyRentSaeCell.CellType(rawValue: indexPath.row)
        return cell!
    }
}

//MARK: TableView Delegate
extension MySaleRentVC {
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return MySaleRentVC.CellHeight
    }
}