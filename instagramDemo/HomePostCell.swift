//
//  HomePostCell.swift
//  instagramDemo
//
//  Created by Omry Dabush on 02/05/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit

class HomePostCell: UICollectionViewCell {
    
    let imageProfileSize = CGFloat(40)
	var delegate : HomePostCellDelegate?
    
    var post : Post? {
        didSet {
            guard let imageURL = post?.imageURL else {return}
            photoImageView.loadImage(ImageURL: imageURL)
            guard let profieImageURL = post?.user.profileImageURL else {return}
            userProfileImage.loadImage(ImageURL: profieImageURL)
            guard let profileName = post?.user.username else {return}
            userProfileName.text = profileName
			guard let hasLike = post?.hasLikes else { return }
			likeButton.setImage(hasLike ?
				#imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal)
				:
				#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal)
				, for: .normal)
            
            setupAttributedCaption()
            
        }
    }
    
    let userProfileImage : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let userProfileName : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let moreButton : UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("•••", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        return bt
    }()
    
    let photoImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var likeButton : UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
		bt.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return bt
    }()
    
    lazy var commentButton : UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
		bt.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return bt
    }()
    
    let sendMessageButton : UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return bt
    }()
    
    let bookmarkButton : UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return bt
    }()
    
    let captionLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
	
	@objc func handleLike() {
		self.delegate?.didLike(for: self)
	}
	
	@objc func handleComment() {
		guard let post = self.post else { return }
		self.delegate?.didTapComment(post: post)
	}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(userProfileImage)
        userProfileImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topPadding: 12, leftPadding: 12, bottomPadding: 0, rightPadding: 0, width: self.imageProfileSize, height: self.imageProfileSize)
        userProfileImage.layer.cornerRadius = imageProfileSize / 2
        userProfileImage.image = #imageLiteral(resourceName: "user")
        
        addSubview(userProfileName)
        userProfileName.anchor(top: topAnchor, left: userProfileImage.rightAnchor, bottom: nil, right: nil, topPadding: 20, leftPadding: 8, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
        
        addSubview(moreButton)
        moreButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, topPadding: 12, leftPadding: 0, bottomPadding: 0, rightPadding: 12, width: 0, height: 0)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: userProfileImage.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topPadding: 8, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
        
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        setupActionButtons()
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topPadding: 0, leftPadding: 8, bottomPadding: 0, rightPadding: 8, width: 0, height: 0)
        
    }
    fileprivate func setupAttributedCaption(){
        guard let post = self.post else {return}
		let timeAgoDisplay = post.creatinDate.timeAgoDisplay()
		
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 4)]))
        attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor : UIColor.gray]))
        
        captionLabel.attributedText = attributedText
    }
    
    
    fileprivate func setupActionButtons() {
        let stackview = UIStackView(arrangedSubviews: [likeButton,commentButton,sendMessageButton])
        stackview.distribution = .fillEqually
        
        addSubview(stackview)
        stackview.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topPadding: 0, leftPadding: 4, bottomPadding: 0, rightPadding: 0, width: 120, height: 40)
        
        addSubview(bookmarkButton)
        bookmarkButton.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 4, width: 40, height: 30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
