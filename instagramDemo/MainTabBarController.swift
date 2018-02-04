//
//  MainTabBarController.swift
//  instagramDemo
//
//  Created by Omry Dabush on 14/04/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController, UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        
        if index == 2 {
            
            let layout = UICollectionViewFlowLayout()
            let addPhotoViewController = AddPhotoController(collectionViewLayout: layout)
            let NavController = UINavigationController(rootViewController: addPhotoViewController)
            
            present(NavController, animated: true, completion: nil)
            
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
		if Auth.auth().currentUser == nil {
            //Lets the UIwindow to load the tabbarController and then present the LoginController
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navigationController = UINavigationController(rootViewController: loginController)
                self.present(navigationController, animated: true, completion: nil)
            }
            return
        }
		
        self.delegate = self
        setupViewControllers()
    
    }
    
    func setupViewControllers() {
        //home
        let homeNavConroller = templateNavController(unSelected: #imageLiteral(resourceName: "home_unselected"), selected: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //Search
        let searchController = templateNavController(unSelected: #imageLiteral(resourceName: "search_unselected"), selected: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //Add Photo
        let plusNavContoller = templateNavController(unSelected: #imageLiteral(resourceName: "plus"), selected: #imageLiteral(resourceName: "plus"))
        
        //Like 
        let likeNavController = templateNavController(unSelected: #imageLiteral(resourceName: "like_unselected"), selected: #imageLiteral(resourceName: "like_selected"))
        
        //User Profile
        let layout = UICollectionViewFlowLayout()
        let userProfileVC = UserProfileController(collectionViewLayout: layout)
        
        let userProfileNavController = UINavigationController(rootViewController: userProfileVC)
        
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_unselected")
        
        
        
        tabBar.tintColor = .black
        viewControllers = [homeNavConroller,searchController,plusNavContoller, likeNavController, userProfileNavController]
        
        //Modify tab bar item insets
        guard let items = tabBar.items else {return}
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        }
    }
    
    fileprivate func templateNavController(unSelected : UIImage, selected: UIImage, rootViewController : UIViewController = UIViewController()) -> UINavigationController {
        
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.tabBarItem.image = unSelected
        navController.tabBarItem.selectedImage = selected
        
        return navController
    }
}
