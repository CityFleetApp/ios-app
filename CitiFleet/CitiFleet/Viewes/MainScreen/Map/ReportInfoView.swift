//
//  ReportInfoView.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/11/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class ReportInfoView: UIView {
    private static let NibName = "ReportInfoView"
    
    @IBOutlet var icon: UIImageView!
    @IBOutlet var distanceLbl: UILabel!
    
    var report: Report! {
        didSet {
            let currLocation = LocationManager.sharedInstance().currentCoordinates
            let fromLocation = CLLocation(latitude: currLocation.latitude, longitude: currLocation.longitude)
            let toLocation = CLLocation(latitude: report.latitude, longitude: report.longitude)
            let distance = fromLocation.distanceFromLocation(toLocation) * Constant.MilesCoefficient
            distanceLbl.text = String(format: "In %.02f miles", distance)
            icon.image = report.icon
        }
    }
    
    class func viewFromNib() -> ReportInfoView {
        let view = NSBundle.mainBundle().loadNibNamed(ReportInfoView.NibName, owner: self, options: nil).first as! ReportInfoView
        return view
    }
}
