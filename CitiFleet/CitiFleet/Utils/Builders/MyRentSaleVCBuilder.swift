//
//  MyRentSaleVCBuilder.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/19/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class MyRentSaleVCBuilder: NSObject {
    enum Type {
        case Rent
        case Sale
    }
    
    func createRent() -> MySaleRentVC {
        return MySaleRentVC()
    }
    
    func createSale() -> MySaleRentVC {
        return MySaleRentVC()
    }
}
