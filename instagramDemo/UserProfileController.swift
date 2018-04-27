//
//  UserProfileController.swift
//  instagramDemo
//
//  Created by Omry Dabush on 14/04/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController : UICollectionViewController{
	
	var user : User?
	var userId : String?
	var posts = [Post]()
	var isGridView = true
	var didFinishPaging = false
	let cellID = Shared.shared().cellID
	let homePostCellID = Shared.shared().homePostCellID
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView?.backgroundColor = .white
		collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerid")
		collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellID)
		collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellID)
		
		fetchUser()
		setupLogOutButton()
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		collectionView?.reloadData()
	}
	
	fileprivate func fetchUser() {
		let userUid = userId ?? Shared.shared().currenUser?.uid ?? ""
		Database.fetchUserWithUID(uid: userUid) { (user) in
			self.user = user
			self.collectionView?.reloadData()
			self.navigationItem.title = self.user?.username
			//			self.fetchOrderedPosts()
			self.paginatePosts()
		}
	}
	
	fileprivate func paginatePosts() {
		guard let uid = self.user?.uid else { return }
		let ref = Database.database().reference().child("posts").child(uid)
		
//		var query = ref.queryOrderedByKey()
		var query = ref.queryOrdered(byChild: "creationDate")
		
		if (posts.count > 0) {
//			let value = posts.last?.id
			let value = posts.last?.creatinDate.timeIntervalSince1970
			query = query.queryEnding(atValue: value)
		}
		
		query.queryLimited(toLast: 4).observeSingleEvent(of: .value, with: { (snapshot) in
			guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
			guard let user = self.user else { return }
			
			 allObjects.reverse()
			
			if allObjects.count < 4 {
				self.didFinishPaging = true
			}
			
			if self.posts.count > 0 && allObjects.count > 0 {
				allObjects.removeFirst()
			}
			
			allObjects.forEach({ (snapshot) in
				guard let dictionary = snapshot.value as? [String : Any] else { return }
				var post = Post(user: user, dictionary: dictionary)
				post.id = snapshot.key
				
				self.posts.append(post)
			})
			self.collectionView?.reloadData()
			
		}) { (err) in
			print("Failed to paginate for posts:", err)
		}
	}
	
	fileprivate func fetchOrderedPosts(){
		guard let uid = self.user?.uid else {return}
		let ref = Database.database().reference().child("posts").child(uid)
		
		ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
			guard let dictionary = snapshot.value as? [String : Any] else {return}
			guard let user = self.user else {return}
			let post = Post(user: user, dictionary: dictionary)
			self.posts.insert(post, at: 0)
			
			self.collectionView?.reloadData()
			
		}) { (err) in
			print("Failed to fetch ordered posts", err)
		}
		
	}
	
	fileprivate func setupLogOutButton(){
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
	}
	
	@objc func handleLogout(){
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		
		alertController.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (_) in
			do {
				try Auth.auth().signOut()
				Shared.destroy()
				let loginController = LoginController()
				let navigationController = UINavigationController(rootViewController: loginController)
				self.present(navigationController, animated: true, completion: nil)
				
			}catch let signoutError {
				print("Failed to signout", signoutError.localizedDescription)
			}
		}))
		
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		present(alertController, animated: true, completion: nil)
	}
}

extension UserProfileController: UICollectionViewDelegateFlowLayout {
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		
		//we know the the header is of type UserProfileHeader because we registed the class in view did load
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerid", for: indexPath) as! UserProfileHeader
		header.delegate = self
		header.user = user
		return header
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if indexPath.item == self.posts.count - 1 && !didFinishPaging {
			print("Paginating for posts")
			paginatePosts()
		}
		if isGridView {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UserProfilePhotoCell
			cell.post = posts[indexPath.item]
			return cell
		}else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellID, for: indexPath) as! HomePostCell
			cell.post = posts[indexPath.item]
			return cell
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize(width: view.frame.width, height: 200)
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return posts.count
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if isGridView {
			let cellsize = (view.frame.width - 2) / 3
			return CGSize(width: cellsize, height: cellsize)
		}else {
			var height = CGFloat(8 + 40 + 8) //Profile image with spacing
			height += view.frame.width //Making the image 1:1 ratio
			height += 50 // Action buttons area
			height += 40 //Comment area
			return CGSize(width: view.frame.width, height: height)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
}

extension UserProfileController: UserProfileHeaderDelegate {
	
	func didChangeToGridView() {
		isGridView = true
		collectionView?.reloadData()
	}
	
	func didChangeToListView() {
		isGridView = false
		collectionView?.reloadData()
	}
	
	
	
	
}
