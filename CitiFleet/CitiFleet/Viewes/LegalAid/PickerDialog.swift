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
    @IBOutlet var bluredBackground: UIImageView!
    @IBOutlet var selectBtn: UIButton!
    
    var components: [String]?
    var complation: ((index: Int?, title: String?, closed: Bool) -> ())?
    
    class func viewFromNib() -> PickerDialog {
        let view = NSBundle.mainBundle().loadNibNamed(XIB.PickerDialog, owner: self, options: nil).first as! PickerDialog
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBluredBackground()
        selectBtn.addBorders(0.5, positions: [.Top, .Bottom], color: UIColor.grayColor())
        if components != nil {
            picker.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    private func setupBluredBackground() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        visualEffectView.frame = bluredBackground.bounds
        bluredBackground.addSubview(visualEffectView)
    }
}

//MARK: Appearing
extension PickerDialog {
    func showOnView(view: UIView) {
        frame = view.bounds
        alpha = 0
        pickerContainerView.alpha = 0
        view.addSubview(self)
        picker.reloadAllComponents()
        animationAppearing()
    }
    
    private func hide(selectedRow: Int?, selectedTitle: String?, closed: Bool) {
        animationDisappearing {
            if let complation = self.complation {
                complation(index: selectedRow, title: selectedTitle, closed: closed)
            }
        }
    }
    
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
        let selectedRow: Int? = components != nil ? picker.selectedRowInComponent(0) : nil
        let selectedTitle: String? = components != nil ? components![selectedRow!] : nil
        hide(selectedRow, selectedTitle: selectedTitle, closed: false)
    }
    
    @IBAction func close(sendor: AnyObject!) {
        hide(nil, selectedTitle: nil, closed: true)
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