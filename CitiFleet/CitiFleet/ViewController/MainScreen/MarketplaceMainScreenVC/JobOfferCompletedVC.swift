//
//  JobOfferCompletedVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/29/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import Cosmos

class JobOfferCompletedVC: UIViewController {
    static let StoryboardID = "JobOfferCompletedVC"
    @IBOutlet var jobTitle: UILabel?
    @IBOutlet var ratingView: CosmosView?
    
    var paidOnTime = true
    var jobOffer: JobOffer? {
        didSet {
            jobTitle?.text = jobOffer?.jobTitle
        }
    }
    
    override func viewDidLoad() {
        jobTitle?.text = jobOffer?.jobTitle
        ratingView?.rating = 0
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
        if jobOffer == nil {
            return
        }
        
        typealias Param = Params.Posting.JOPosting
        let params = [
            Param.rating: Int((ratingView?.rating)!),
            Param.paidOnTime: paidOnTime
        ]
        
        RequestManager.sharedInstance().post("\(URL.Marketplace.JobOffers)\((jobOffer!.id)!)\(URL.Marketplace.CompleteJob)", parameters: params as? [String : AnyObject]) { [weak self] (json, error) in
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