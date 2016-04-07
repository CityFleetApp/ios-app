//
//  PostingPhotosCollectionDelegate.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/28/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import Haneke

class PostingPhotosCollectionDelegate: VehicleCollectionViewDelegate {
    override func downloadPhotos() {
        
    }
    
    override func selectedImage(selectedImage: UIImage) {
        let image = GalleryPhoto(image: selectedImage, imageData: nil, attributedCaptionTitle: NSAttributedString(string: ""), largePhotoURL: nil, thumbURL: nil, id: nil)
        images.append(image)
        reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellID.Profile.VehiclePhotoCell, forIndexPath: indexPath) as! VehiclePhotoCell
        let image = images.count > indexPath.item ? images[indexPath.item].image : UIImage(named: Resources.Profile.VehicleDefault)
        if image == nil && images[indexPath.item].largePhotoURL != nil  {
            cell.photo.hnk_setImageFromURL(images[indexPath.item].largePhotoURL!)
        } else {
            cell.photo.image = image
        }
        cell.deleteItem = { [unowned self] (deleted, error) in
            if deleted {
                self.images.removeAtIndex(indexPath.item)
                self.reloadData()
            }
        }
        return cell
    }
}
