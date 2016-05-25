//
//  JobOfferInfoVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/4/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class JobOfferInfoVC: UITableViewController {
    class var StoryboardID: String {
        return "JobOfferInfoVC"
    }
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var destination: UILabel!
    @IBOutlet var payLbl: UILabel!
    @IBOutlet var tollsLbl: UILabel!
    @IBOutlet var gratuityLbl: UILabel!
    @IBOutlet var vehicleLbl: UILabel!
    @IBOutlet var suiteLbl: UILabel!
    @IBOutlet var companyLbl: UILabel!
    @IBOutlet var jobTypeLbl: UILabel!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var requestButton: UIButton?
    @IBOutlet var authorLabel: UILabel!

    var job: JobOffer!
    
    class func viewControllerFromStoryboard() -> JobOfferInfoVC {
        let storyboard = UIStoryboard(name: Storyboard.MarketPlace, bundle: nil)
        if let viewController = storyboard.instantiateViewControllerWithIdentifier(JobOfferInfoVC.StoryboardID) as? JobOfferInfoVC {
            return viewController
        } else {
            return JobOfferInfoVC()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.hidden = false
        dateLbl.text = NSDateFormatter.standordFormater().stringFromDate(job.pickupDatetime!)
        timeLbl.text = NSDateFormatter(dateFormat: "hh:mm a").stringFromDate(job.pickupDatetime!)
        addressLbl.text = job.pickupAddress
        destination.text = job.destination
        payLbl.text = "$ \(job.fare!)"
        if let tolls = job.tolls {
            tollsLbl.text = "$ \(tolls)"
        } else {
            tollsLbl.text = "$ 0.00"
        }
        gratuityLbl.text = "$ \(job.gratuity!)"
        vehicleLbl.text = job.vehicleType
        suiteLbl.text = job.suite == true ? "Yes" : "No"
        if let author = job.authorType {
            companyLbl.text = author.rawValue
        } else {
            companyLbl.text = "Personal"
        }
        authorLabel.text = job.ownerName
        jobTypeLbl.text = job.jobType
        titleLbl.text = job.jobTitle
        
        requestButton?.enabled = (job.requested) != true
    }
    
    @IBAction func jobInfo(sender: AnyObject) {
        RequestManager.sharedInstance().post("\(URL.Marketplace.JobOffers)\(job.id!)\(URL.Marketplace.RequestJob)", parameters: nil) { [weak self] (json, error) in
            if error == nil {
                let alert = UIAlertController(title: "Job Request Sent", message: nil, preferredStyle: .Alert)
                let action = UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
                    self?.navigationController?.popViewControllerAnimated(true)
                })
                alert.addAction(action)
                self?.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 8 {
            let profileVC = ProfileVC.viewControllerFromStoryboard()
            profileVC.user = job.user
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

class JobOfferAwardedVC: JobOfferInfoVC {
    @IBOutlet var completeBtn: UIButton!
    
    override class var StoryboardID: String {
        return "JobOfferAwardedVC"
    }
    
    override class func viewControllerFromStoryboard() -> JobOfferInfoVC {
        let storyboard = UIStoryboard(name: Storyboard.MarketPlace, bundle: nil)
        if let viewController = storyboard.instantiateViewControllerWithIdentifier(JobOfferAwardedVC.StoryboardID) as? JobOfferAwardedVC {
            return viewController
        } else {
            return JobOfferAwardedVC()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completeBtn.enabled = job.awarded == true && job.ownerID != User.currentUser()?.id
    }
    
    override func jobInfo(sender: AnyObject) {
        if let vc = storyboard?.instantiateViewControllerWithIdentifier(JobOfferCompletedVC.StoryboardID) as? JobOfferCompletedVC {
            vc.jobOffer = job
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
