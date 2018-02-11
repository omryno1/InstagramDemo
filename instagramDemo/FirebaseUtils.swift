//
//  FirebaseUtils.swift
//  instagramDemo
//
//  Created by Omry Dabush on 20/05/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import Foundation
import Firebase

extension Database {
	
	
	//MARK: - Posts
	static func fetchAllPosts(currentUserID : String, complition : @escaping ([Post])->()) {
		
		let dispatchGroup = DispatchGroup()		
		self.fetchUserPosts(userID: currentUserID, dispatchGroup: dispatchGroup)
		self.fetchPostsFromUsersIFollow(currentUserID: currentUserID, dispatchGroup: dispatchGroup)
		
		dispatchGroup.notify(queue: DispatchQueue.main) {
			complition(Shared.shared().allPosts)
		}
	}
	
	static func fetchUserPosts(userID : String, dispatchGroup : DispatchGroup) {
		dispatchGroup.enter()
		self.fetchUserWithUID(uid: userID) { (user) in
			self.fetchPostsWithUser(user: user, success: { (success) in
				if (success) {
					dispatchGroup.leave()
				}
			})
		}
	}
	
	static func fetchPostsFromUsersIFollow(currentUserID : String, dispatchGroup : DispatchGroup){
		self.fetchUsersIFollow(uid: currentUserID, complition: { (followingDictionary) in
			followingDictionary.forEach({ (key, value) in
				fetchUserPosts(userID: key, dispatchGroup: dispatchGroup)
			})
		})
	}
	
	static func fetchUserWithUID(uid : String, complition : @escaping (User)->()) {
		Database.database().reference().child("Users").child(uid).observe(.value, with: { (snapshot) in
			guard let userDictionary = snapshot.value as? [String : Any] else {return}
			
			let user = User(uid: uid, dictionary: userDictionary)
			complition(user)
			
		}) { (err) in
			print("Failed to load User", err)
		}
	}
	
	 static func fetchUsersIFollow(uid : String, complition : @escaping ([String : Any])->()){
		Database.database().reference().child("Following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
			if (snapshot.hasChildren()){
				guard let followingDictionary = snapshot.value as? [String : Any] else { return }
				complition(followingDictionary)
			}
		}) { (err) in
			print("Failed to fetch following id's")
		}
	}
	
	
	private static func fetchPostsWithUser(user : User, success : @escaping (Bool)->()) {
		let ref = Database.database().reference().child("posts").child(user.uid)
		ref.observeSingleEvent(of: .value, with: { (snapshot) in
			
			if (snapshot.hasChildren()){
				guard let dictionaries = snapshot.value as? [String : Any] else {return}
				dictionaries.forEach({ (key, value) in
					guard let dictionary = value as? [String : Any] else {return}
					
					var post = Post(user: user, dictionary: dictionary)
					post.id = key
					Shared.shared().allPosts.append(post)
				})
				
				Shared.shared().allPosts.sort(by: { (p1, p2) -> Bool in
					return p1.creatinDate.compare(p2.creatinDate) == .orderedDescending
				})
				
			}
			success(true)
			
		}) { (error) in
			print("Failed to fetch posts", error)
			success(false)
		}
	}
	//MARK: - Comments
	static func postCommentToFirebaseDatabase(postID: String, postData : [String : Any], complition : @escaping (Bool)->()) {
		Database.database().reference().child("Comments").child(postID).childByAutoId().updateChildValues(postData) { (err, ref) in
			if let err = err {
				print("Failed to upload Comment", err)
				complition(false)
				return
			}
			
			print("Successfully uploaded the comment")
			complition(true)
		}
	}
	
	static func fetchPostComments(postID : String, complition : @escaping ([Comment])->()){
		var comments = [Comment]()
		Database.database().reference().child("Comments").child(postID).observe(.childAdded, with: { (snapshot) in
			guard let dictionary = snapshot.value as? [String : Any] else { return }
			
			let comment = Comment(dictionary: dictionary)
			comments.append(comment)
			
			complition(comments)
			
		}) { (err) in
			print("Failed to fetch Post comments", err)
			return
		}
	}
}
