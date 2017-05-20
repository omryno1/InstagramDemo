//
//  SearchController.swift
//  instagramDemo
//
//  Created by Omry Dabush on 20/05/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit

class SearchController : UICollectionViewController, UICollectionViewDelegateFlowLayout   {
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        collectionView?.backgroundColor = .white
        collectionView?.register(SearchCell.self, forCellWithReuseIdentifier: cellID)
        
    collectionView?.alwaysBounceVertical = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SearchCell
        
        return cell
    }
}
