//
//  JobOfferCompletedVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/29/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire

class JobOfferCompletedVC: UIViewController {
    class var StoryboardID: String {
        return "JobOfferCompletedVC"
    }
    @IBOutlet var jobTitle: UILabel?
    @IBOutlet var ratingView: CosmosView?
    
    var paidOnTime = true
    var jobOffer: JobOffer? {
        didSet {
            setupJobOffer(jobOffer)
        }
    }
    
    override func viewDidLoad() {
        setupJobOffer(jobOffer)
        ratingView?.rating = 0
    }
    
    internal func setupJobOffer(job: JobOffer?) {
        jobTitle?.text = job?.jobTitle
    }
}

//MARK: - Private Methods 
extension JobOfferCompletedVC {
    private func shouldSendRequest() -> Bool {
        if ratingView?.rating < 1 {
            let alert = UIAlertController(title: Titles.JobOffers.NoRatingTitle, message: Titles.JobOffers.NoRatingMsg, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: Titles.cancel, style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true, completion: nil)
            
            return false
        }
        return true
    }
    
    private func previousViewController() -> UIViewController? {
        if let indexVC = navigationController?.viewControllers.indexOf(self) {
            if let _ = navigationController?.viewControllers[indexVC - 1] as? JobOfferAwardedVC {
                return navigationController?.viewControllers[indexVC - 2]
            } else {
                return navigationController?.viewControllers[indexVC - 1]
            }
        }
        return nil
    }
}

//MARK: - Actions 
extension JobOfferCompletedVC {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func paidOnTimeChanged(sender: AnyObject) {
        if let switcher = sender as? UISwitch {
            paidOnTime = switcher.on
        }
    }
    
    @IBAction func submit(sender: AnyObject) {
        if jobOffer == nil && !shouldSendRequest() {
            return
        }
        
        typealias Param = Params.Posting.JOPosting
        let params = [
            Param.rating: String( Int((ratingView?.rating)!)),
            Param.paidOnTime: paidOnTime ? "true" : "false"
        ]
        
        RequestManager.sharedInstance().post("\(URL.Marketplace.JobOffers)\((jobOffer!.id)!)\(URL.Marketplace.CompleteJob)", parameters: params) { [weak self] (json, error) in
            if self == nil {
                return
            }
            if error == nil {
                if let vc = self?.previousViewController() {
                    self?.navigationController?.popToViewController(vc, animated: true)
                } else {
                    self?.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
        }
    }
}

class JobOfferCompletedByUserVC: JobOfferCompletedVC {
    @IBOutlet var driverName: UILabel?
    var driver: String?
    
    override class var StoryboardID: String {
        return "JobOfferCompletedByUserVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        driverName?.text = driver
    }
    
    override func submit(sender: AnyObject) {
        if jobOffer == nil && !shouldSendRequest() {
            return
        }
        
        typealias Param = Params.Posting.JOPosting
        let params = [
            Param.rating: String( Int((ratingView?.rating)!))
        ]
        
        RequestManager.sharedInstance().post("\(URL.Marketplace.JobOffers)\((jobOffer!.id)!)\(URL.Marketplace.RateDriver)", parameters: params) { [weak self] (json, error) in
            if self == nil {
                return
            }
            if error == nil {
                if let vc = self?.previousViewController() {
                    self?.navigationController?.popToViewController(vc, animated: true)
                } else {
                    self?.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
        }
    }
}