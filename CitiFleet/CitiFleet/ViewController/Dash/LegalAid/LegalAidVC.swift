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
}
