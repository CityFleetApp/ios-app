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
    var cellBuilder: DOCManagementCellBuilder?
    
    override func viewDidLoad() {
        cellBuilder = DOCManagementCellBuilder(tableView: tableView, docManager: docManager)
        docManager.loadDocuments { [weak self] (docs, error) -> () in
            if error == nil {
                self?.tableView.reloadData()
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
        return (cellBuilder?.build(indexPath))!
    }
}

extension DOCManagementVC {
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let type = Document.CellType(rawValue: indexPath.row)
        let cell = cell as! DOCManagementCell
        cell.title.text = DOCManagementCellBuilder.titles[indexPath.row]
        cell.docType = type
        cellBuilder?.setActionsForCell(cell, type: type)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CellHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? DOCManagementCell
        cell?.didSelect()
    }
}