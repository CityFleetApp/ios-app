//
//  MyRentSaeCell.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/19/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class MyRentSaeCell: LegalAidCell {
    enum CellType: Int {
        case Make = 0
        case Model = 1
        case Type = 2
        case Color = 3
        case Year = 4
        case Fuel = 5
        case Seats = 6
        case Price = 7
        case Description = 8
    }
    
    private let iconNames = [
        "rs-make-ic",
        "rs-madel-ic",
        "rs-type-ic",
        "rs-color-ic",
        "rs-year-ic",
        "rs-fuel-ic",
        "rs-seats-ic",
        "rs-price-ic",
        "rs-description-ic"
    ]
    
    private let titles = [
        "Make",
        "Model",
        "Type",
        "Color",
        "Year",
        "Fuel",
        "Seats",
        "Price",
        "Description"
    ]
    
    private let placeHolders = [
        "Select Make",
        "Select Model",
        "Select Type",
        "Select Color",
        "Slect Year",
        "Select Fule",
        "Select Seats",
        "Slect Price",
        "Provide Description"
    ]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var type: CellType! {
        didSet {
            setup()
            setEditable(true)
        }
    }
    
    private func setup() {
        let typeIndex = type.rawValue
        title.text = titles[typeIndex]
        placeHolder?.placeholderText = placeHolders[typeIndex]
        icon.image = UIImage(named: iconNames[typeIndex])
    }
}

class MyRentSaleDescriptionCell: MyRentSaeCell {
    
}