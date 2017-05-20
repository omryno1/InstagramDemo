//
//  FirebaseUtils.swift
//  instagramDemo
//
//  Created by Omry Dabush on 20/05/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import Foundation
import Firebase

extension FIRDatabase {
    static func fetchUserWithUID(uid : String, complition : @escaping (User)->()) {
        
        FIRDatabase.database().reference().child("Users").child(uid).observe(.value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String : Any] else {return}
            
            let user = User(uid: uid, dictionary: userDictionary)
            complition(user)
            
        }) { (err) in
            print("Failed to load User", err)
        }
    }
}
