//
//  UserProfileHeader.swift
//  instagramDemo
//
//  Created by Omry Dabush on 15/04/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit

class UserProfileHeader : UICollectionViewCell {
    
    
    var user : User? {
        didSet {
            setupProfileImage()
            usernameLabel.text = user?.username
        }
    }
    
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        return iv
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookMarksButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postsLabel :  UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSForegroundColorAttributeName : UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followersLabel :  UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSForegroundColorAttributeName : UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followingLabel :  UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSForegroundColorAttributeName : UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let editProfileButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topPadding: 12, leftPadding: 12, bottomPadding: 0, rightPadding: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        profileImageView.image = #imageLiteral(resourceName: "user")
        
        setupUserStats()
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, topPadding: 2, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 34)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topPadding: 12, leftPadding: 20, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
        
        setupBottomToolBar()
        
    }
    
    fileprivate func setupUserStats(){
        
        let stackView = UIStackView(arrangedSubviews: [postsLabel,followersLabel,followingLabel])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, topPadding: 12, leftPadding: 12, bottomPadding: 0, rightPadding: 12, width: 0, height: 50)
    }
    
    fileprivate func setupBottomToolBar(){
    
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookMarksButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: frame.width, height: 50)
    
        let topDivider = UIView()
        topDivider.backgroundColor = UIColor.lightGray
        
        addSubview(topDivider)
        
        topDivider.anchor(top: stackView.topAnchor , left: leftAnchor, bottom: nil, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0.5)
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = UIColor.lightGray
        
        addSubview(bottomDivider)
        
        bottomDivider.anchor(top: stackView.bottomAnchor , left: leftAnchor, bottom: nil, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0.5)
    
    }
    
    fileprivate func setupProfileImage(){
        guard let profileImageURL = user?.profileImageURL else { return }
        profileImageView.loadImage(ImageURL: profileImageURL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
