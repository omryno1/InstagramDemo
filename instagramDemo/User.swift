//
//  User.swift
//  instagramDemo
//
//  Created by Omry Dabush on 26/04/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit

struct User {
    
    let uid : String
    let username : String
    let profileImageURL : String
    
    init(uid : String, dictionary : [String : Any]) {
        self.uid = uid
        self.username = dictionary["Username"] as? String ?? ""
        self.profileImageURL = dictionary["profile_image_URL"] as? String ?? ""
    }
}
