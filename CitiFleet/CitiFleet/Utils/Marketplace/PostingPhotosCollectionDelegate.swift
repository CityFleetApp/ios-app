//
//  PostingPhotosCollectionDelegate.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/28/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import Haneke
import NYTPhotoViewer

class PostingPhotosCollectionDelegate: VehicleCollectionViewDelegate {
    override func downloadPhotos() {
        let urls = images
            .filter({ return $0.largePhotoURL != nil })
            .map({ return ($0.largePhotoURL)! })
        
        for url in urls {
            let index = urls.indexOf(url)
            Shared.imageCache.fetch(URL: url).onSuccess { [weak self] (image) in
                dispatch_async(dispatch_get_main_queue()) {
                    self?.reloadItem?(NSIndexPath(forItem: index!, inSection: 0))
                }
            }
        }
    }
    
    override func deletePhoto(photo: NYTPhoto) {
        let galleryPhoto = photo as! GalleryPhoto
        if let imageIndex = images.indexOf(galleryPhoto) {
            let cell = cellAtIndexPath(indexPath: NSIndexPath(forItem: imageIndex, inSection: 0)) as? VehiclePhotoCell
            cell?.photo.image = UIImage(named: Resources.Profile.VehicleDefault)
            if let index = galleryPhoto.id {
                deletedImagesIDs.append(index)
            }
            if let index = images.indexOf(photo as! GalleryPhoto) {
                images.removeAtIndex(index)
            }
        }
    }
    
    override func selectedImage(selectedImage: UIImage) {
        let image = GalleryPhoto(image: selectedImage, imageData: nil, attributedCaptionTitle: NSAttributedString(string: ""), largePhotoURL: nil, thumbURL: nil, id: nil)
        images.append(image)
        reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellID.Profile.VehiclePhotoCell, forIndexPath: indexPath) as! VehiclePhotoCell
        let image = images.count > indexPath.item ? images[indexPath.item].image : UIImage(named: Resources.Profile.VehicleDefault)
        cell.photo.image = nil
        for subviewe in cell.photo.subviews {
            subviewe.removeFromSuperview()
        }
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        if image == nil && images[indexPath.item].largePhotoURL != nil  {
            cell.photo.addSubview(indicator)
            indicator.startAnimating()
            indicator.center = cell.photo.center
        } else {
            cell.photo.image = image
        }
        cell.deleteItem = { [weak self] (deleted, error) in
            if deleted {
                if let photoID = self?.images[indexPath.item].id {
                    self?.deletedImagesIDs.append(photoID)
                }
                self?.images.removeAtIndex(indexPath.item)
                self?.reloadData()
            }
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        let photo = images[indexPath.item]
        deletePhoto(photo)
    }
}
