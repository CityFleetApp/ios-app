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

    var job: JobOffer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLbl.text = NSDateFormatter(dateFormat: "dd/MM/yy").stringFromDate(job.pickupDatetime!)
        timeLbl.text = NSDateFormatter(dateFormat: "hh:mm a").stringFromDate(job.pickupDatetime!)
        addressLbl.text = job.pickupAddress
        destination.text = job.destination
        payLbl.text = job.fare
        tollsLbl.text = "0.00"
        gratuityLbl.text = job.gratuity
        vehicleLbl.text = job.vehicleType
        suiteLbl.text = job.suite == true ? "Yes" : "No"
        companyLbl.text = "Personal"
        jobTypeLbl.text = job.jobType
    }
    
    @IBAction func jobInfo(sender: AnyObject) {
        RequestManager.sharedInstance().post("\(URL.Marketplace.JobOffers)\(job.id!)\(URL.Marketplace.RequestJob)", parameters: nil) { [weak self] (json, error) in
            if error == nil {
                self?.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
}

class JobOfferAwardedVC: JobOfferInfoVC {
    @IBOutlet var completeBtn: UIButton!
    
    override class var StoryboardID: String {
        return "JobOfferAwardedVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completeBtn.enabled = job.awarded == true
    }
    
    override func jobInfo(sender: AnyObject) {
        if let vc = storyboard?.instantiateViewControllerWithIdentifier(JobOfferCompletedVC.StoryboardID) as? JobOfferCompletedVC {
            vc.jobOffer = job
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
