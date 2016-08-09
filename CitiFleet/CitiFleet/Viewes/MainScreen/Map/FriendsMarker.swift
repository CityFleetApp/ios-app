//
//  FriendsMarker.swift
//  CitiFleet
//
//  Created by Nick Kibish on 4/12/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class FriendsMarkerView: UIView {
    static let NibName = "FriendsMarker"
    
    let preferedWidth: CGFloat = 85
    let imageHeight: CGFloat = 45
    let imageWidth: CGFloat = 35
    let standardPadding: CGFloat = 8
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameBG: UIView!
    
    var name: String! {
        didSet {
            nameLabel.text = name
            frame.origin = CGPoint(x: 0, y: 0)
            frame.size = getPreferedSize()
        }
    }
    
    class func viewFromNib() -> FriendsMarkerView {
        guard let view = NSBundle.mainBundle().loadNibNamed(FriendsMarkerView.NibName, owner: self, options: nil).first as? FriendsMarkerView else { return FriendsMarkerView() }
        return view
    }
    
    func imageFromView() -> UIImage {
        return UIImage.imageWithView(self)
    }
    
    func getPreferedSize() -> CGSize {
        var size = nameLabel.sizeThatFits(CGSize(width: preferedWidth, height: CGFloat(MAXFLOAT)))
        size.height += imageHeight + standardPadding * 2
        size.width = max(size.width, imageWidth) + standardPadding * 2
        return size
    }
    
}
