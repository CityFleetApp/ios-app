//
//  PostingsVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/20/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class PostingsVC: UITableViewController {
    private let bgImageName = "postings_bg"
    
    override func viewDidLoad() {
        tableView.backgroundView = UIImageView(image: UIImage(named: bgImageName))
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.hidden = false
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.setZeroSeparator(cell)
    }
}
