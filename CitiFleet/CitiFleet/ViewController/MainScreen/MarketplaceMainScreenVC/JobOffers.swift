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
    @IBOutlet var availableJobBtn: UIButton!
    var isFiltered = false
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        reloadData()
    }
    
    func reloadData () {
        dataSource.loadData { [weak self] (error) in
            if error == nil {
                self?.jobOfferTableView.reloadData()
                self?.availableJobBtn.setTitle("\((self?.dataSource.availableItems.count)!) Jobs available", forState: .Normal)
            }
        }
    }
}

extension JobOffersVC {
    @IBAction func showAllJobOffers(sender: AnyObject) {
        if isFiltered {
            isFiltered = false
            jobOfferTableView.reloadData()
        }
    }
    
    @IBAction func showAvailableJobOffers(sender: AnyObject) {
        if !isFiltered {
            isFiltered = true
            jobOfferTableView.reloadData()
        }
    }
}

extension JobOffersVC: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltered ? dataSource.availableItems.count : dataSource.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellID = JobOfferTableViewCell.jobsReuseIdentifier
        var cell = tableView.dequeueReusableCellWithIdentifier(CellID) as? JobOfferTableViewCell
        if cell == nil {
            cell = JobOfferTableViewCell(style: .Default, reuseIdentifier: CellID)
        }
        
        let items = isFiltered ? dataSource.availableItems : dataSource.items
        let item = items[indexPath.row]
        cell?.title.text = "\(NSDateFormatter(dateFormat: "hh:mm a").stringFromDate(item.pickupDatetime!)) | $\(item.gratuity!))"
        cell?.dateLabel?.text = NSDateFormatter(dateFormat: "dd/MM/yyyy").stringFromDate(item.pickupDatetime!)
        cell?.jobStateLabel.text = item.status
        cell?.setEditable(true)
        cell?.notificationTitle?.text = item.instructions
        
        return cell!
    }
}

extension JobOffersVC: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = dataSource.items[indexPath.row]
        let vc = storyboard?.instantiateViewControllerWithIdentifier(JobOfferInfoVC.StoryboardID)
        
        if let viewController = vc as? JobOfferInfoVC {
            viewController.job = item
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 81
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.setZeroSeparator(cell)
    }
}