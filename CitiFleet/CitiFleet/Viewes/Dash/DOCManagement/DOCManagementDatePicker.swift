//
//  DOCManagementDatePicker.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/22/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class DOCManagementDatePicker: DialogView {
    @IBOutlet var selectBtn: UIButton!
    @IBOutlet var buttonContainerView: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    
    override class func viewFromNib() -> DOCManagementDatePicker {
        guard let view = NSBundle.mainBundle().loadNibNamed(XIB.DOCManagementDatePicekr, owner: self, options: nil).first as? DOCManagementDatePicker else { return DOCManagementDatePicker(frame: CGRectZero) }
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonContainerView.addBorders(0.5, positions: [.Top, .Bottom], color: UIColor.grayColor())
    }
}

extension DOCManagementDatePicker {
    @IBAction func selectDate(sender: AnyObject?) {
        let selectedDate = datePicker.date
        hide(selectedDate, closed: false)
    }
    
    @IBAction func close(sendor: AnyObject!) {
        hide(nil, closed: true)
    }
}