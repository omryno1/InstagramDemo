//
//  HomeController.swift
//  instagramDemo
//
//  Created by Omry Dabush on 02/05/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit
import Firebase

class HomeController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	let cellId = "cellId"
	var posts = [Post]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView?.backgroundColor = .white
		collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
		
		fetchPosts()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.posts.removeAll()
		fetchPosts()
	}
	
	fileprivate func fetchPosts() {
		guard let UserUID = Shared.shared().currenUser?.uid else { return }

		Database.database().reference().child("Following").child(UserUID).observeSingleEvent(of: .value, with: { (snapshot) in
			guard let followingDictionary = snapshot.value as? [String : Any] else {
				self.posts.removeAll()
				self.collectionView?.reloadData()
				return
			}
			followingDictionary.forEach({ (key, value) in
				Database.fetchUserWithUID(uid: key, complition: { (user) in
					self.fetchPostsWithUser(user: user)
				})
			})
			
		}) { (err) in
			print("Failed to fetch following id's")
		}
		
//		Database.fetchUserWithUID(uid: UserUID) { (user) in
//			self.fetchPostsWithUser(user: user)
//		}
		
	}
	
	fileprivate func fetchPostsWithUser(user : User) {
		let ref = Database.database().reference().child("posts").child(user.uid)
		ref.observeSingleEvent(of: .value, with: { (snapshot) in
			guard let dictionaries = snapshot.value as? [String : Any] else {return}
			
			dictionaries.forEach({ (key, value) in
				
				guard let dictionary = value as? [String : Any] else {return}
				
				let post = Post(user: user, dictionary: dictionary)
				self.posts.append(post)
			})
			
			self.posts.sort(by: { (p1, p2) -> Bool in
				return p1.creatinDate.compare(p2.creatinDate) == .orderedDescending
			})
			
			self.collectionView?.reloadData()
			
		}) { (error) in
			print("Failed to fetch posts", error)
		}
	}
	
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
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
		
		cell.post = posts[indexPath.item]
		
		return cell
	}
}
