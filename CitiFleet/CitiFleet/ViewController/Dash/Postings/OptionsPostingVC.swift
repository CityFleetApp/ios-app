//
//  OptionsPostingVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/20/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class OptionsPostingVC: UITableViewController {
    private let CellID = "PostingCell"
    var numborOfRows: Int!
    var iconNames: [String]!
    var titles: [String]!
    var placeholders: [String]!
}

extension OptionsPostingVC {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numborOfRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellID) as? PostingCell
        if cell == nil {
            cell = PostingCell(style: .Default, reuseIdentifier: CellID)
        }
        
        let index = indexPath.row
        cell?.icon.image = UIImage(named: iconNames[index])?.imageWithRenderingMode(.AlwaysTemplate)
        cell?.title.text = titles[index]
        cell?.placeHolder?.placeholderText = placeholders[index]
        cell?.setEditable(true)
        
        return cell!
    }
}