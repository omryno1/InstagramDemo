//
//  PhotoPreviewHeader.swift
//  instagramDemo
//
//  Created by Omry Dabush on 20/04/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit

class PhotoPreviewHeader : UICollectionViewCell {
    let imagePreview : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imagePreview)
        imagePreview.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
