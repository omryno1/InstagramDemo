//
//  CommentCell.swift
//  instagramDemo
//
//  Created by Omry Dabush on 06/02/2018.
//  Copyright © 2018 Omry Dabush. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
	
	var comment : Comment? {
		didSet {
			textlabel.text = comment?.commentText
		}
	}
	
	let textlabel : UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14)
		label.backgroundColor = UIColor.lightGray
		label.numberOfLines = 0
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .yellow
		
		addSubview(textlabel)
		textlabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topPadding: 4, leftPadding: 4, bottomPadding: 4, rightPadding: 4, width: 0, height: 0)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
