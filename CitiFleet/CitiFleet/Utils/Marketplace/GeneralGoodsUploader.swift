//
//  GeneralGoodsUploader.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/30/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import Foundation

class GeneralGoodsUploader: NSObject {
    var itemName: String?
    var ascingPrice: String?
    var condition: Int?
    var itemDescription: String?
    var photos: [UIImage] = []
    
    func upload(completion: ((NSError?) -> ())) {
        RequestManager.sharedInstance().postGeneralGood(itemName!, price: ascingPrice!, condition: condition!, goodDescription: itemDescription!, images: photos, completion: completion)
    }
}
