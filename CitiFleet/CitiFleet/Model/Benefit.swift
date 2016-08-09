//
//  Benefit.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/11/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

class BenefitList {
    var benefitList: [Benefit] = []
    
    func getBenefitList(completion: (([Benefit])->())) {
        RequestManager.sharedInstance().getBenefits { [unowned self] (benefits, error) -> () in
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
            guard let imageURLString = benefitObject[Response.Benefits.ImageURL] as? String else { continue }
            guard let title = benefitObject[Response.Benefits.Title] as? String else { continue }
            let barcode = benefitObject[Response.Benefits.Barcode] as? String
            let promoCode = benefitObject[Response.Benefits.PromoCode] as? String
            
            guard let url = NSURL(string: imageURLString) else { continue }
            
            let benefit = Benefit(imageURL: url, barcode: barcode, title: title, promoCode: promoCode)
            
            self.benefitList.append(benefit)
        }
    }
}

struct Benefit {
    var imageURL: NSURL
    var barcode: String?
    var title: String
    var promoCode: String?
}
