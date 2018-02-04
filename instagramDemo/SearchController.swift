//
//  SearchController.swift
//  instagramDemo
//
//  Created by Omry Dabush on 20/05/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit
import Firebase

class SearchController : UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
//    let cellID = "cellID"
	let cellID = Shared.shared().cellID
	var users = [User]()
	var filterdUser = [User]()
	
	lazy var searchBar : UISearchBar = {
		let sb = UISearchBar()
		sb.placeholder = "Enter username"
		sb.barTintColor = UIColor.gray
		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
		sb.delegate = self
		return sb
	}()
	
	//MARK: - Retain Cycle Methods
	
	override func viewDidLoad() {
		
		let navBar = navigationController?.navigationBar
		navBar?.addSubview(searchBar)
		searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, topPadding: 0, leftPadding: 8, bottomPadding: 0, rightPadding: 8, width: 0, height: 0)
		
		collectionView?.backgroundColor = .white
		collectionView?.register(SearchCell.self, forCellWithReuseIdentifier: cellID)
		collectionView?.alwaysBounceVertical = true
		collectionView?.keyboardDismissMode = .onDrag
		fetchUsers()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.searchBar.isHidden = false
	}
	
	private func fetchUsers() {
		let ref = Database.database().reference().child("Users")
		ref.observeSingleEvent(of: .value, with: { (snapshot) in
			guard let dictionaries = snapshot.value as? [String : Any] else { return }
			
			dictionaries.forEach({ (key, value) in
				if (key == Shared.shared().currenUser?.uid) { return }
				guard let dictionary = value as? [String : Any] else { return }
				let user = User(uid: key, dictionary: dictionary)
				self.users.append(user)
			})
			
			self.users.sort { (u1, u2) -> Bool in
				return u1.username.compare(u2.username) == .orderedAscending
			}
		
			self.filterdUser = self.users
			self.collectionView?.reloadData()
			
		}) { (err) in
			print("Failed to fetch users")
		}
	}
	// MARK: - SearchBar Delegate
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		if searchText.isEmpty {
			filterdUser = users
		}else {
			filterdUser = users.filter({ (user) -> Bool in
				return user.username.lowercased().contains(searchText.lowercased())
			})
		}
		collectionView?.reloadData()
	}
	
	// MARK: - collectionView Delegate
	
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterdUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SearchCell
		
		cell.user = self.filterdUser[indexPath.item]
        return cell
    }
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		self.searchBar.isHidden = true
		self.searchBar.resignFirstResponder()
		
		let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
		userProfileController.userId = filterdUser[indexPath.item].uid
		navigationController?.pushViewController(userProfileController, animated: true)
	}
}
