//
//  AvatarRatingView.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/14/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import Cosmos

class AvatarRatingView: AvatarHeaderView {
    @IBOutlet var ratingView: CosmosView!
    
    override func xibName() -> String {
        return XIB.AvatarHeaderView.Rating
    }
}
