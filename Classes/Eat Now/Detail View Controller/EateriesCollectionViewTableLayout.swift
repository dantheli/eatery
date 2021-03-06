//
//  EateruesCollectionViewTableLayout.swift
//  Eatery
//
//  Created by Eric Appel on 12/2/15.
//  Copyright © 2015 CUAppDev. All rights reserved.
//

import UIKit

class EateriesCollectionViewTableLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        super.prepareLayout()
        
        guard let collectionView = collectionView else {return}
        let width = collectionView.bounds.width
        itemSize = CGSize(width: width, height: width * 0.4)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
    }
}
