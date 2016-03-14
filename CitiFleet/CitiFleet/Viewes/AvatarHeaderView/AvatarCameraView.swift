//
//  AvatarCameraView.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/13/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class AvatarCameraView: AvatarHeaderView {
    @IBOutlet var cameraButton: UIButton!
    var cameraAction: ((AnyObject) -> ())?
    
    @IBAction func cameraPressed(sender: AnyObject) {
        if let action = cameraAction {
            action(sender)
        }
    }
    
    override func xibName() -> String {
        return XIB.AvatarHeaderView.Camera
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        cameraButton.setDefaultShadow()
    }
}
