//
//  UserProfileHeader.swift
//  instagramDemo
//
//  Created by Omry Dabush on 15/04/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol UserProfileHeaderDelegate {
	func didChangeToListView()
	func didChangeToGridView()
}

class UserProfileHeader : UICollectionViewCell {
	
	enum EditFollowBtn {
		case Follow
		case unFollow
		case EditProfile
	}
	
    var user : User? {
        didSet {
            setupProfileImage()
            usernameLabel.text = user?.username
			setupEditProfileFollowBtn()
        }
    }
	
	var delegate: UserProfileHeaderDelegate?
	var mainProfileButton = EditFollowBtn.EditProfile
    
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
		iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
		button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        return button
    }()
    
    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
		button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
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
        
		let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
		attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followersLabel :  UILabel = {
        let label = UILabel()
		let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
		attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followingLabel :  UILabel = {
        let label = UILabel()
		let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
		attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var editProfileFollowButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
		button.addTarget(self, action: #selector(handleEditProfileFollowBtn), for: .touchUpInside)
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
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, topPadding: 2, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 34)
        
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
	@objc func setupEditProfileFollowBtn(){
		guard let currentUser = Shared.shared().currenUser else { return }
		guard let userId = user?.uid else { return }
		
		if (currentUser.uid == userId) {
			mainProfileButton = .EditProfile
			setupEditUnFollowStyle(title: "Edit Profile")
		} else {
			Database.database().reference().child("Following").child(currentUser.uid).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
				if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
					self.mainProfileButton = .unFollow
					self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
				}else {
					self.mainProfileButton = .Follow
					self.setupFollowStyle()
				}
			}, withCancel: { (err) in
				print("Faile to verifie if Following : \(err)")
			})
		}
		
	}
	
	@objc func handleEditProfileFollowBtn() {
		guard let currentUser = Shared.shared().currenUser else { return }
		guard let userUid = user?.uid else { return }
		let ref = Database.database().reference().child("Following").child(currentUser.uid)
		
		if (self.mainProfileButton != .EditProfile) {
			if (self.mainProfileButton == .Follow) {
				let values = [userUid : 1]
				ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
					if let err = err {
						print("Failes to Update Child : \(err)")
						return
					}
					
					self.mainProfileButton = .unFollow
					print("Successfully Followed \(self.user?.username ?? "")")
					self.setupEditUnFollowStyle(title: "unFollow")
				})
			}else {
				ref.child(userUid).removeValue(completionBlock: { (err, ref) in
					if let err = err {
						print("Failed to remove Value \(err)")
						return
					}
					
					self.mainProfileButton = .Follow
					print("Succesfully unFollowed \(self.user?.username ?? "")")
					self.setupFollowStyle()
				})
			}
		}else {
			//MARK: Edit Profile Button
		}
		
	}
	
	fileprivate func setupFollowStyle() {
		self.editProfileFollowButton.setTitle("Follow", for: .normal)
		self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
		self.editProfileFollowButton.setTitleColor(.white, for: .normal)
		self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
	}
	
	fileprivate func setupEditUnFollowStyle(title : String){
		self.editProfileFollowButton.setTitle(title, for: .normal)
		self.editProfileFollowButton.backgroundColor = .white
		self.editProfileFollowButton.setTitleColor(.black, for: .normal)
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
	
	@objc fileprivate func handleChangeToGridView() {
		listButton.tintColor = UIColor(white: 0, alpha: 0.2)
		gridButton.tintColor = .mainBlue()
		delegate?.didChangeToGridView()
	}
	
	@objc fileprivate func handleChangeToListView() {
		gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
		listButton.tintColor = .mainBlue()
		delegate?.didChangeToListView()
	}
    
    fileprivate func setupProfileImage(){
        guard let profileImageURL = user?.profileImageURL else { return }
        profileImageView.loadImage(ImageURL: profileImageURL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
