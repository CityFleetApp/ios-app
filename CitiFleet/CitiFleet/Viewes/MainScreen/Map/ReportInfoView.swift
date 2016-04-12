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
    private let ReportInfoViewHeght: CGFloat = 150
    
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
    
    func showView() {
        UIView.animateWithDuration(0.25) { [weak self] in
            if self == nil {
                return
            }
            self?.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: (self?.ReportInfoViewHeght)!)
        }
    }
    
    func hideView() {
        UIView.animateWithDuration(0.25) { [weak self] in
            if self == nil {
                return
            }
            self?.frame = CGRect(x: 0, y: -self!.ReportInfoViewHeght, width: UIScreen.mainScreen().bounds.width, height: (self?.ReportInfoViewHeght)!)
        }
    }
}

extension ReportInfoView {
    @IBAction func confirmReport(sender: AnyObject) {
        if let id = report.id {
            let urlString = "\(URL.Reports.Map)\(id)\(URL.Reports.Confirm)"
            RequestManager.sharedInstance().post(urlString, parameters: nil, completion: { [weak self] (json, error) in
                self?.hideView()
            })
        }
    }
    
    @IBAction func denyReport(sender: AnyObject) {
        if let id = report.id {
            let urlString = "\(URL.Reports.Map)\(id)\(URL.Reports.Deny)"
            RequestManager.sharedInstance().post(urlString, parameters: nil, completion: { [weak self] (json, error) in
                self?.hideView()
            })
        }
    }
}
