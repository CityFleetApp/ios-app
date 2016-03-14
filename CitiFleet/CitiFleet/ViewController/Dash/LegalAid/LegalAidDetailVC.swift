//
//  LegalAidDetailVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/12/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class LegalAidDetailVC: UITableViewController {
    @IBOutlet var actorTitle: UILabel!
    @IBOutlet var actorImage: UIImageView!
    
    @IBOutlet var locationLabel: HighlitableLabel!
    @IBOutlet var actorLabel: HighlitableLabel!
    @IBOutlet var yearsLabel: HighlitableLabel!
    @IBOutlet var nameLabel: HighlitableLabel!
    
    var setuper: LegalAidSetuper?
    
    override func viewDidLoad() {
        if let setuper =  setuper {
            setuper.setupViewController()
        }
    }
}
