//
//  JobOffers.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/4/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class JobOffersVC: UIViewController {
    static let StoryBoardID = "JobOffersVC"
    
    let dataSource = JobOffersDataSource()
    @IBOutlet var jobOfferTableView: UITableView!
    
    override func viewDidLoad() {
        dataSource.loadData { [weak self] (error) in
            if error == nil {
                self?.jobOfferTableView.reloadData()
            }
        }
    }
}

extension JobOffersVC: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellID = JobOfferTableViewCell.jobsReuseIdentifier
        var cell = tableView.dequeueReusableCellWithIdentifier(CellID) as? JobOfferTableViewCell
        if cell == nil {
            cell = JobOfferTableViewCell(style: .Default, reuseIdentifier: CellID)
        }
        
        let item = dataSource.items[indexPath.row]
        cell?.title.text = "\(NSDateFormatter(dateFormat: "hh:mm a").stringFromDate(item.pickupDatetime!)) | $\(item.gratuity!))"
        cell?.dateLabel?.text = NSDateFormatter(dateFormat: "dd/MM/yyyy").stringFromDate(item.pickupDatetime!)
        cell?.placeHolder?.placeholderText = item.instructions
        cell?.jobStateLabel.text = item.status
        cell?.setEditable(true)
        
        return cell!
    }
}

extension JobOffersVC: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 81
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.setZeroSeparator(cell)
    }
}