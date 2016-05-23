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
        dataSource.loadAll { [weak self] (error) in
            if error == nil {
                self?.jobOfferTableView.reloadData()
                self?.availableJobBtn.setTitle("\((self?.dataSource.availableCount)!) Jobs available", forState: .Normal)
            }
        }
    }
}

extension JobOffersVC {
    @IBAction func showAllJobOffers(sender: AnyObject) {
        if isFiltered {
            dataSource.loadAll({ [weak self] (error) in
                if error == nil {
                    self?.jobOfferTableView.reloadData()
                    self?.isFiltered = false
                }
            })
        }
    }
    
    @IBAction func showAvailableJobOffers(sender: AnyObject) {
        if !isFiltered {
            dataSource.loadAvailable({ [weak self] (error) in
                if error == nil {
                    self?.jobOfferTableView.reloadData()
                    self?.isFiltered = true 
                }
            })
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
        
        let separator = UIScreen.mainScreen().bounds.width <= 360 ? "\n" : " | "
        
        cell?.title.text = "\(NSDateFormatter(dateFormat: "hh:mm a").stringFromDate(item.pickupDatetime!))\(separator)$\(item.fare!))"
        cell?.dateLabel?.text = NSDateFormatter(dateFormat: "dd/MM/yyyy").stringFromDate(item.pickupDatetime!)
//        cell?.jobStateLabel.text = item.status?.rawValue
        
        let statusTuple = statusColor(item)
        cell?.jobStateLabel.text = statusTuple.0
        cell?.jobStateLabel.backgroundColor = statusTuple.1
        
        cell?.setEditable(true)
        cell?.notificationTitle?.text = item.jobTitle
        
        return cell!
    }
}

extension JobOffersVC: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = dataSource.items[indexPath.row]
        let vc: JobOfferInfoVC? = storyboard?.instantiateViewControllerWithIdentifier(item.status == .Available ? JobOfferInfoVC.StoryboardID : JobOfferAwardedVC.StoryboardID) as? JobOfferInfoVC
        
        if let viewController = vc {
            viewController.job = item
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 81
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.setZeroSeparator(cell)
        
        if !dataSource.shouldLoadNext {
            return
        }
        
        let startCount = dataSource.items.count
        if indexPath.row == (dataSource.items.count) - 1 {
            dataSource.loadNext({ [weak self] (error) in
                if error != nil || self == nil {
                    return
                }
                
                let endCount = (self?.dataSource.count)!
                if endCount - startCount <= 0 {
                    return
                }
                
                var indexes: [NSIndexPath] = []
                for index in startCount...endCount {
                    indexes.append(NSIndexPath(forRow: index, inSection: 0))
                }
                self?.jobOfferTableView.reloadData()
            })
        }
    }
}

//MARK: - Private Methods
extension JobOffersVC {
    private func statusColor(job: JobOffer) -> (String, UIColor) {
        if job.status == .Covered {
            return ((job.status?.rawValue)!, UIColor(hex: Color.JobOffer.Orange, alpha: 1))
        } else if job.requested == true {
            return ("Requested", UIColor(hex: Color.JobOffer.Orange, alpha: 1))
        } else if job.awarded == true {
            return ("Awarded", UIColor(hex: Color.JobOffer.Orange, alpha: 1))
        } else if job.status == .Available {
            return ("Available", UIColor(hex: Color.JobOffer.Green, alpha: 1))
        }
        
        return ("", UIColor.clearColor())
    }
}