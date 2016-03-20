//
//  PicerDialog.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/14/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class PickerDialog: DialogView {
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var selectBtn: UIButton!
    @IBOutlet var buttonContainerView: UIView!
    
    var components: [String]?
    
    override class func viewFromNib() -> PickerDialog {
        let view = NSBundle.mainBundle().loadNibNamed(XIB.PickerDialog, owner: self, options: nil).first as! PickerDialog
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonContainerView.addBorders(0.5, positions: [.Top, .Bottom], color: UIColor.grayColor())
        if components != nil {
            picker.selectRow(0, inComponent: 0, animated: false)
        }
    }
}

extension PickerDialog {
    @IBAction func selectElement(sender: AnyObject?) {
        let selectedRow: Int? = components != nil ? picker.selectedRowInComponent(0) : nil
        hide(selectedRow, closed: false)
    }
    
    @IBAction func close(sendor: AnyObject!) {
        hide(nil, closed: true)
    }
}

extension PickerDialog: UIPickerViewDataSource {
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return components != nil ? components!.count : 0
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
}

extension PickerDialog: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if components == nil {
            return nil
        }
        let title = components![row]
        let attributedTitle = NSAttributedString(string: title, attributes: [
            NSFontAttributeName:Fonts.PickerDialog.PicerRowFort,
            NSForegroundColorAttributeName:Color.PickerDialog.RowTextColor])
        return attributedTitle
    }
}