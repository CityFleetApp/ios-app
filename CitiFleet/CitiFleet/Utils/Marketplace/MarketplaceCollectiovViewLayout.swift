//
//  MarketplaceCollectiovViewLayout.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/31/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

protocol MarketplaceLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
    func collectionView(collectionView: UICollectionView, heightForInfoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
    func collectionView(collectionView: UICollectionView, heightForDescriptionAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
}

class MarketplaceLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var photoHeight: CGFloat = 0
    var infoHeight: CGFloat = 0
    var descriptionHeight: CGFloat = 0
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! MarketplaceLayoutAttributes
        copy.photoHeight = photoHeight
        copy.infoHeight = infoHeight
        copy.descriptionHeight = descriptionHeight
        return copy
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let attributes = object as? MarketplaceLayoutAttributes {
            if attributes.photoHeight == photoHeight &&
                attributes.infoHeight == infoHeight &&
                attributes.descriptionHeight == descriptionHeight {
                return super.isEqual(object)
            }
        }
        return false
    }
    
}

class MarketplaceCollectiovViewLayout: UICollectionViewLayout {
    var cellPadding: CGFloat = 0
    var delegate: MarketplaceLayoutDelegate!
    var numberOfColumns = 1
    var columnWidth: CGFloat {
        get {
            let columnWidth = width / CGFloat(numberOfColumns)
            return columnWidth - (cellPadding * 2)
        }
    }
    
    var cache = [MarketplaceLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    private var width: CGFloat {
        get {
            let insets = collectionView!.contentInset
            return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
        }
    }
    
//    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//        <#code#>
//    }
    
    override class func layoutAttributesClass() -> AnyClass {
        return MarketplaceLayoutAttributes.self
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    override func prepareLayout() {
        contentHeight = 0
        let columnWidth = width / CGFloat(numberOfColumns)
        
        var xOffsets = [CGFloat]()
        for column in 0..<numberOfColumns {
            xOffsets.append(CGFloat(column) * columnWidth)
        }
        
        var yOffsets = [CGFloat](count: numberOfColumns, repeatedValue: 0)
        
        var column = 0
        for item in 0..<collectionView!.numberOfItemsInSection(0) {
            let indexPath = NSIndexPath(forItem: item, inSection: 0)
            
            let width = self.columnWidth
            let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath, withWidth: width)
            let infoHeight = delegate.collectionView(collectionView!, heightForInfoAtIndexPath: indexPath, withWidth: width)
            let descriptionHeght = delegate.collectionView(collectionView!, heightForDescriptionAtIndexPath: indexPath, withWidth: width)
            let height = cellPadding + photoHeight + infoHeight + descriptionHeght + cellPadding
            
            let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
            let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
            
            var attributes: MarketplaceLayoutAttributes!
            let firstElement = cache.filter() { $0.indexPath.row == item }.first
            
            if let attr = firstElement {
                attributes = attr
            } else {
                attributes = MarketplaceLayoutAttributes(forCellWithIndexPath: indexPath)
            }
            attributes.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            
            attributes.frame = insetFrame
            attributes.photoHeight = photoHeight
            attributes.infoHeight = infoHeight
            attributes.descriptionHeight = descriptionHeght
            
            cache.append(attributes)
            contentHeight = max(contentHeight, CGRectGetMaxY(frame))
            yOffsets[column] = yOffsets[column] + height
            column = column >= (numberOfColumns - 1) ? 0 : (column + 1)
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
