//
//  BenefitsVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/10/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit

class BenefitsVC: UIViewController {

}

extension BenefitsVC: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellID = "BenefitsCollectionViewCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath)
        cell.setDefaultShadow()
        return cell
    }
}

class BenefitsCollectionViewCell: UICollectionViewCell {
    
}