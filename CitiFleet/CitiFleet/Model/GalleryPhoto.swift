//
//  GalleryPhoto.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/15/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import NYTPhotoViewer
import Kingfisher

class GalleryPhoto: NSObject, NYTPhoto {
    var image: UIImage?
    var thumbImage: UIImage? {
        didSet {
            if image == nil {
                image = thumbImage
            }
        }
    }
    var imageData: NSData?
    var placeholderImage: UIImage?
    let attributedCaptionTitle: NSAttributedString?
    let attributedCaptionSummary: NSAttributedString? = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
    let attributedCaptionCredit: NSAttributedString? = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
    
    var largePhotoURL: NSURL
    var thumbURL: NSURL
    var id: Int
    
    init(image: UIImage? = nil, imageData: NSData? = nil, attributedCaptionTitle: NSAttributedString, largePhotoURL: NSURL, thumbURL: NSURL, id: Int) {
        self.image = image
        self.imageData = imageData
        self.attributedCaptionTitle = attributedCaptionTitle
        self.largePhotoURL = largePhotoURL
        self.thumbURL = thumbURL
        self.id = id 
        super.init()
        
        let downloadManager = KingfisherManager.sharedManager
        downloadManager.retrieveImageWithURL(largePhotoURL, optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
            self.image = image
            NSNotificationCenter.defaultCenter().postNotificationName(NYTPhotoViewControllerPhotoImageUpdatedNotification, object: self)
        }
        
        if thumbImage == nil {
            downloadManager.retrieveImageWithURL(thumbURL, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) -> () in
                self.thumbImage = image
            })
        }
    }
}
