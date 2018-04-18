//
//  HomeController.swift
//  instagramDemo
//
//  Created by Omry Dabush on 02/05/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit
import Firebase

class HomeController : UICollectionViewController {
	
//	let cellID = "cellId"
	let cellID = Shared.shared().homePostCellID
	var posts = [Post]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: SharePhotoController.updateFeedNotificationName, object: nil)
		
		collectionView?.backgroundColor = .white
		collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellID)
		
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
		collectionView?.refreshControl = refreshControl
		setupNavigationItems()
		fetchAllPosts()
	}
	
	func fetchAllPosts(){
		guard let userID = Shared.shared().currenUser?.uid else { return }
		Database.fetchAllPosts(currentUserID: userID) { (posts) in
			self.posts = posts
			self.EndRefredhing()
			self.collectionView?.reloadData()
		}
	}
	
	@objc func handleRefresh(){
		print("refreshing ...")
		collectionView?.isUserInteractionEnabled = false
		Shared.shared().allPosts.removeAll()
		fetchAllPosts()
	}
	
	@objc func EndRefredhing() {
		self.collectionView?.refreshControl?.endRefreshing()
		self.collectionView?.isUserInteractionEnabled = true
		self.collectionView?.reloadData()
	}
	
	fileprivate func fetchPostsWithUser(user : User) {
		let ref = Database.database().reference().child("posts").child(user.uid)
		ref.observeSingleEvent(of: .value, with: { (snapshot) in
			guard let dictionaries = snapshot.value as? [String : Any] else {return}
			dictionaries.forEach({ (key, value) in
				
				guard let dictionary = value as? [String : Any] else {return}
				
				var post = Post(user: user, dictionary: dictionary)
				post.id = key
				self.posts.append(post)
			})
			
			self.posts.sort(by: { (p1, p2) -> Bool in
				return p1.creatinDate.compare(p2.creatinDate) == .orderedDescending
			})
			
			self.EndRefredhing()
			
		}) { (error) in
			print("Failed to fetch posts", error)
		}
	}
	
	fileprivate func setupNavigationItems(){
		navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "LeftNavBtn").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
	}
	
	@objc fileprivate func handleCamera(){
		let cameraVC = CameraController()
		present(cameraVC, animated: true, completion: nil)
	}
	
}

extension HomeController : HomePostCellDelegate, UICollectionViewDelegateFlowLayout {
	
	//HomePostCellDelegate
	func didTapComment(post: Post) {
		let commentsController = CommentsConroller(collectionViewLayout: UICollectionViewFlowLayout())
		commentsController.post = post
		self.hidesBottomBarWhenPushed = true
		navigationController?.pushViewController(commentsController, animated: true)
		self.hidesBottomBarWhenPushed = false
	}
	
	func didLike(for cell: HomePostCell) {
		guard let indexPath = collectionView?.indexPath(for: cell) else { return }
		var post = posts[indexPath.item]
		
		guard let currentUserUid = Shared.shared().currenUser?.uid else { return }
		guard let postId = post.id else { return }
		let values = [currentUserUid: post.hasLikes ? 0 : 1]
		
		Database.changePostLike(postId: postId, values: values) { (success) in
			if (success) {
				post.hasLikes = !post.hasLikes
				self.posts[indexPath.item] = post
				self.collectionView?.reloadItems(at: [indexPath])
			}
		}
	}
	
	//CollectionView Delegate
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return posts.count
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		var height = CGFloat(8 + 40 + 8) //Profile image with spacing
		height += view.frame.width //Making the image 1:1 ratio
		height += 50 // Action buttons area
		height += 40 //Comment area
		return CGSize(width: view.frame.width, height: height)
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomePostCell
		
		cell.post = posts[indexPath.item]
		cell.delegate = self
		return cell
	}
}
