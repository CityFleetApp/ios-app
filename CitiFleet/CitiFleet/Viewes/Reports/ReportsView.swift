//
//  ReportsView.swift
//  CitiFleet
//
//  Created by Nick Kibish on 2/29/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class ReportsView: UIView {
    @IBOutlet var bgImage: UIImageView!
    @IBOutlet var bgView: UIView!
    @IBOutlet var reportMenu: UIView!
    
    @IBOutlet var policeBtn: UIButton!
    @IBOutlet var tlcBtn: UIButton!
    @IBOutlet var accountBtn: UIButton!
    @IBOutlet var traficBtn: UIButton!
    @IBOutlet var hazardBtn: UIButton!
    @IBOutlet var roadClosureBtn: UIButton!
    
    class func reportFromNib() -> ReportsView {
        let reportView = NSBundle.mainBundle().loadNibNamed(XIB.ReportXIB, owner: self, options: nil).first as! ReportsView
        return reportView
    }
    
    func show(onViewController viewController: UIViewController) {
        frame = viewController.view.bounds
        centerButtons()
        
        bgView.alpha = 0
        bgImage.alpha = 0
        reportMenu.alpha = 0
        
        animationAppearing()
        viewController.view.addSubview(self)
    }
    
    func hide() {
        animationDisappearing { () -> () in
            self.removeFromSuperview()
        }
    }
    
    func centerButtons() {
        let buttons = [
            policeBtn,
            tlcBtn,
            accountBtn,
            traficBtn,
            hazardBtn,
            roadClosureBtn
        ]
        
        roadClosureBtn.centerImageAndTitle(0)
        for button in buttons {
            button.centerImageAndTitle(-5)
        }
    }
    
    func takeScreenshot(viewController:UIViewController) -> UIImage {
        UIGraphicsBeginImageContext(viewController.view.frame.size)
        viewController.view.drawViewHierarchyInRect(viewController.view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

//MARK: - Actions
extension ReportsView {
    @IBAction func close(sender: AnyObject) {
        animationDisappearing {
            self.removeFromSuperview()
        }
    }
    
    @IBAction func postReport(sender: AnyObject) {
        let currentPosition = LocationManager.sharedInstance().currentCoordinates
        let report = Report(lat: 40.715421, lon: -73.825984, type: ReportType(rawValue: 1)!)
        report.post { (error) -> () in
            if let error = error {
                RequestErrorHandler(error: error, title: Titles.error).handle()
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.hide()
            })
        }
    }
}

//MARK: - Animation
extension ReportsView {
    func animationAppearing() {
        animate(1.0, toRequestAlpha: 1.0, complation: nil)
    }
    
    func animationDisappearing(complation:(()->())) {
        animate(0.0, toRequestAlpha: 0.0, complation: complation)
    }
    
    func animate(toBgAlpha: CGFloat, toRequestAlpha: CGFloat, complation:(()->())?) {
        UIView.animateWithDuration(0.125,
            animations: {
                self.bgImage.alpha = toBgAlpha
                self.bgView.alpha = toBgAlpha
            }, completion: {finished in
                self.animateReportView(toRequestAlpha, complation: complation)
        })
    }
    
    func animateReportView(newAlpha: CGFloat, complation:(()->())?) {
        UIView.animateWithDuration(0.125,
            animations:  {
            self.reportMenu.alpha = newAlpha
            }, completion:  {finished in
                complation?()
        })
    }
}
