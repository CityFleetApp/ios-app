//
//  DOCManagementVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/22/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class DOCManagementVC: UITableViewController {
    var DOCManagementCellID: String = "DOCManagementCellID"
    var CellHeight: CGFloat = 121
    var docManager = DOCManager()
    
    override func viewDidLoad() {
        docManager.loadDocuments { (docs, error) -> () in
            if error == nil {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.hidden = false
    }
}

extension DOCManagementVC {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return DOCManagementCellBuilder(tableView: tableView, indexPath: indexPath, docManager: docManager).build()
    }
}

extension DOCManagementVC {
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CellHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! DOCManagementCell
        cell.didSelect()
    }
}