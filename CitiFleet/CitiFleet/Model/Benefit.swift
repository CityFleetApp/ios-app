//
//  Benefit.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/11/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

class BenefitList {
    private var benefitList: [Benefit] = []
    
    func getBenefitList(completion: (([Benefit])->())) {
        RequestManager.sharedInstance().getBenefits { (benefits, error) -> () in
            self.benefitList.removeAll()
            if let benefits = benefits {
                self.parseBenefits(benefits)
            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(self.benefitList)
            }
        }
    }
    
    private func parseBenefits(benefits: [AnyObject]) {
        for benefitObject in benefits {
            let imageURLString = benefitObject[Response.Benefits.ImageURL] as! String
            let title = benefitObject[Response.Benefits.Title] as! String
            let barcode = benefitObject[Response.Benefits.Barcode] as! String
            
            self.benefitList.append(Benefit(imageURL: NSURL(string: imageURLString)!, barcode: barcode, title: title))
        }
    }
}

struct Benefit {
    var imageURL: NSURL
    var barcode: String
    var title: String
}
