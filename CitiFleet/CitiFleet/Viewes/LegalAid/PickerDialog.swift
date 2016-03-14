//
//  PicerDialog.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/14/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class PickerDialog: UIView {
    @IBOutlet var pickerContainerView: UIView!
    @IBOutlet var picker: UIPickerView!
    var components: [String]!
    var complation: ((index: Int?, title: String?, closed: Bool) -> ())?
    
    class func viewFromNib() -> PickerDialog {
        let view = NSBundle.mainBundle().loadNibNamed(XIB.PickerDialog, owner: self, options: nil).first as! PickerDialog
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        picker.selectRow(0, inComponent: 0, animated: false)
    }
    
    func showOnView(view: UIView) {
        animationAppearing()
    }
    
    private func hide(selectedRow: Int?, selectedTitle: String?, closed: Bool) {
        animationDisappearing {
            if let complation = self.complation {
                complation(index: selectedRow, title: selectedTitle, closed: closed)
            }
        }
    }
}

//MARK: Appearing
extension PickerDialog {
    private func animationAppearing() {
        animate(1.0, toRequestAlpha: 1.0, complation: nil)
    }
    
    private func animationDisappearing(complation:(()->())) {
        animate(0.0, toRequestAlpha: 0.0, complation: complation)
    }
    
    private func animate(toBgAlpha: CGFloat, toRequestAlpha: CGFloat, complation:(()->())?) {
        UIView.animateWithDuration(0.125,
            animations: {
                self.alpha = toBgAlpha
            }, completion: {finished in
                self.animateReportView(toRequestAlpha, complation: complation)
        })
    }
    
    private func animateReportView(newAlpha: CGFloat, complation:(()->())?) {
        UIView.animateWithDuration(0.125,
            animations:  {
                self.pickerContainerView.alpha = newAlpha
            }, completion:  {finished in
                complation?()
        })
    }
}

extension PickerDialog {
    @IBAction func selectElement(sender: AnyObject?) {
        let selectedRow = picker.selectedRowInComponent(0)
        let selectedTitle = components[selectedRow]
        hide(selectedRow, selectedTitle: selectedTitle, closed: false)
    }
    
    @IBAction func close(sendor: AnyObject!) {
        hide(nil, selectedTitle: nil, closed: true)
    }
}

extension PickerDialog: UIPickerViewDataSource {
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return components.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
}

extension PickerDialog: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = components[row]
        let attributedTitle = NSAttributedString(string: title, attributes: [
            NSFontAttributeName:Fonts.PickerDialog.PicerRowFort,
            NSForegroundColorAttributeName:Color.PickerDialog.RowTextColor])
        return attributedTitle
    }
}