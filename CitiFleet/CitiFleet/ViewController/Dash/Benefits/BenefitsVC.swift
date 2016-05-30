//
//  BenefitsVC.swift
//  CitiFleet
//
//  Created by Nick Kibish on 3/10/16.
//  Copyright © 2016 Nick Kibish. All rights reserved.
//

import UIKit
import Haneke

class BenefitsVC: UIViewController {
    private var benefits = BenefitList()
    
    @IBOutlet var benefitCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        loadBenefits()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.hidden = false
    }
    
    func loadBenefits() {
        benefits.getBenefitList { (benefits) in
            self.benefitCollectionView.reloadData()
        }
    }
}

extension BenefitsVC: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let benefit = benefits.benefitList[indexPath.row]
        if benefit.promoCode != nil && benefit.promoCode?.characters.count > 0 {
            let benefitsView = DiscountCodeView.discountFromNib()
            benefitsView.benefit = benefit
            benefitsView.show(view)
        } else if benefit.barcode != nil && benefit.barcode?.characters.count > 0 {
            let benefitsView = BarcodeView.barcodeFromNib()
            benefitsView.benefit = benefit
            benefitsView.show(view)
        }
        
    }
}

extension BenefitsVC: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return benefits.benefitList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellID = CellID.BenefitCellID
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! BenefitsCollectionViewCell
        cell.setDefaultShadow()
        
        let benefit = benefits.benefitList[indexPath.item]
        cell.title.text = benefit.title
        cell.barcode = benefit.barcode
        cell.thumbnail.hnk_setImageFromURL(benefit.imageURL)
        
        return cell
    }
}

class BenefitsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var thumbnail: UIImageView!
    var barcode: String?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.cornerRadius = 5
        contentView.clipsToBounds = true
    }
}
