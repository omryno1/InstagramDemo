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
			guard let comment = comment else { return }
			
			let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
			attributedText.append(NSAttributedString(string: " "+comment.commentText, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)]))

			textlabel.attributedText = attributedText
			profileImage.loadImage(ImageURL: comment.user.profileImageURL)
		}
	}
	
	let textlabel : UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14)
		label.numberOfLines = 0
		return label
	}()
	
	let profileImage : CustomImageView = {
		let image = CustomImageView()
		image.clipsToBounds = true
		image.contentMode = .scaleAspectFill
		return image
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(profileImage)
		profileImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topPadding: 8, leftPadding: 8, bottomPadding: 0, rightPadding: 0, width: 40, height: 40)
		profileImage.layer.cornerRadius = 20
		
		addSubview(textlabel)
		textlabel.anchor(top: topAnchor, left: profileImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topPadding: 4, leftPadding: 8, bottomPadding: 4, rightPadding: 4, width: 0, height: 0)
		
		let lineSeperatorView = UIView()
		lineSeperatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
		addSubview(lineSeperatorView)
		lineSeperatorView.anchor(top: nil, left: textlabel.leftAnchor, bottom: bottomAnchor, right: textlabel.rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0.7)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
