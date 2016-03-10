//
//  BenefitsLayout.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/10/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class BenefitsLayout: UICollectionViewLayout {
    static let coef = CGFloat(841) / CGFloat(1175)
    static let bottomLineHeight: CGFloat = 55
    static let margin: CGFloat = 16
    
    var numberOfColumns = 1
    var cellPadding: CGFloat = 8
    
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    private var width: CGFloat {
        get {
            return CGRectGetWidth(UIScreen.mainScreen().bounds) - BenefitsLayout.margin * 2
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    override func prepareLayout() {
        if cache.isEmpty {
            let columnWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
            var y = cellPadding
            
            for item in 0..<collectionView!.numberOfItemsInSection(0) {
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                
                let width = columnWidth - (cellPadding * 2)
                let photoHeight = (columnWidth - cellPadding * 2) * BenefitsLayout.coef
                let annotationHeight = BenefitsLayout.bottomLineHeight
                let height = photoHeight + annotationHeight
                
                let frame = CGRect(x: cellPadding, y: y, width: width, height: height)
                let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                contentHeight = max(contentHeight, CGRectGetMaxY(frame) + cellPadding)
                y = CGRectGetMaxY(frame) + cellPadding
            }
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
