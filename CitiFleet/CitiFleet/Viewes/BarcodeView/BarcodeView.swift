//
//  BarcodeView.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/11/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class BarcodeView: UIView {
    @IBOutlet var barcodeLabel: UILabel!
    @IBOutlet var barcodeImageView: UIImageView?
    var benefit: Benefit? {
        didSet {
            if let barcode = benefit?.barcode {
                barcodeImageView?.image = UIImageManager().generateBarcodeFromString(barcode)
                barcodeLabel.text = barcode
            }
        }
    }
    
    class func barcodeFromNib() -> BarcodeView {
        guard let reportView = NSBundle.mainBundle().loadNibNamed(XIB.BarcodeXIB, owner: self, options: nil).first as? BarcodeView else { return BarcodeView() }
        return reportView
    }
    
    func show(view: UIView) {
        frame = view.bounds
        alpha = 0
        view.addSubview(self)
        UIView.animateWithDuration(0.25) {
            self.alpha = 1
        }
    }
    
    @IBAction func hide(sender: AnyObject) {
        UIView.animateWithDuration(0.25,
            animations: {
                self.alpha = 0
            }, completion: { completed in
                self.removeFromSuperview()
        })
    }
}


class DiscountCodeView: BarcodeView {
    override var benefit: Benefit? {
        didSet {
            if let barcode = benefit?.promoCode {
                barcodeLabel.text = barcode
            }
        }
    }
    
    class func discountFromNib() -> DiscountCodeView {
        guard let discountView = NSBundle.mainBundle().loadNibNamed(XIB.DiscountXIB, owner: self, options: nil).first as? DiscountCodeView else { return DiscountCodeView() }
        return discountView
    }
}