//
//  CommentsController.swift
//  instagramDemo
//
//  Created by Omry Dabush on 31/01/2018.
//  Copyright © 2018 Omry Dabush. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CommentsConroller: UICollectionViewController{
	
	var post : Post?
	var comments = [Comment]()
	let cellID = Shared.shared().cellID
	let date = Date().timeIntervalSince1970
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Comments"
		navigationController?.navigationBar.isHidden = false
		collectionView?.backgroundColor = .blue
	
		collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellID)
		
		fetchComments()
	}
	
	let textField : CustomSearchTextField = {
		let textField = CustomSearchTextField()
		textField.placeholder = "Add a Comment..."
		textField.layer.cornerRadius = 17
		textField.layer.masksToBounds = true
		textField.font = UIFont.systemFont(ofSize: 14)
		textField.layer.borderColor = UIColor.gray.cgColor
		textField.layer.borderWidth = 1.0
		return textField
	}()
	
	let postButton : UIButton = {
		let postButton = UIButton(type: .system)
		postButton.setTitle("Post", for: .normal)
		postButton.setTitleColor(.black, for: .normal)
		postButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		postButton.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
		return postButton
	}()
	
	lazy var inputContainerView : UIView = {
		let containerView = CustomUIView()
		let width = UIScreen.main.bounds.width
		containerView.backgroundColor = .white
		containerView.frame = CGRect(x: 0, y: 0, width: width, height: 50)
		
		containerView.addSubview(postButton)
		containerView.addSubview(textField)
		containerView.autoresizingMask = .flexibleHeight

		postButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.layoutMarginsGuide.bottomAnchor, right: containerView.rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 8, rightPadding: 12, width: 50, height: 0)
		
		textField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.layoutMarginsGuide.bottomAnchor, right: postButton.leftAnchor, topPadding: 8, leftPadding: 8, bottomPadding: 8, rightPadding: 8, width: 0, height: 34)
		
		return containerView
	}()
	
	override var inputAccessoryView: UIView? {
		get {
			return inputContainerView
		}
	}
	
	override var canBecomeFirstResponder: Bool {
		return true
	}
	
	fileprivate func fetchComments() {
		guard let postID = post?.id else { return }
		Database.fetchPostComments(postID: postID) { (comments) in
			self.comments = comments
			self.collectionView?.reloadData()
		}
		
	}
	
	@objc func handlePost() {
		print("posting your comment")
		
		guard let commentText = textField.text else { return }
		guard let uid = Shared.shared().currenUser?.uid else { return }
		guard let postID = post?.id else { return }
		
		let comment = ["uid" : uid, "creationDate" : date, "commentText" : commentText] as [String : Any]
		
		Database.postCommentToFirebaseDatabase(postID: postID, postData: comment) { (success) in
			if (success) {
				self.textField.text = ""
			}
		}
	}
}

extension CommentsConroller : UICollectionViewDelegateFlowLayout {
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.comments.count
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width, height: 50)
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CommentCell
		cell.comment = self.comments[indexPath.item]
		return cell
	}
}

class CustomUIView : UIView {
	override var intrinsicContentSize: CGSize {
		return CGSize.zero
	}
}

