//
//  LegalAidVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/12/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class LegalAidVC: UITableViewController {
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.hidden = false
        setBackgroundTableView()
    }
    
    private func setBackgroundTableView() {
        let bgView = NSBundle.mainBundle().loadNibNamed(XIB.LegalAidXIB, owner: self, options: nil).first as! UIView
        tableView.backgroundView = bgView
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var type = LegalAidType.DMVLawyer
        switch (segue.identifier)! {
        case SegueID.LegalAid2Details.DMWLawyers:
            type = .DMVLawyer
            break
        case SegueID.LegalAid2Details.TLCLawyers:
            type = .TLCLawyer
            break
        case SegueID.LegalAid2Details.Accountants:
            type = .Accountants
            break
        case SegueID.LegalAid2Details.Brokers:
            type = .InsuranceBrokers
            break
        default:
            break
        }
        
        if let legalAidDetail = segue.destinationViewController as? LegalAidDetailVC {
            let setuper = LegalAidSetuper(legalAidVC: legalAidDetail, type: type)
            legalAidDetail.setuper = setuper
        }
    }
}
