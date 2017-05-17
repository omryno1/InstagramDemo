//
//  PhotoThumbnailCell.swift
//  instagramDemo
//
//  Created by Omry Dabush on 18/04/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit

class PhotoThumbnail : UICollectionViewCell {
    
    let imageThumbnail : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageThumbnail)
        imageThumbnail.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
