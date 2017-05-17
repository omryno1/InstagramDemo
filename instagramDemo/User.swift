//
//  User.swift
//  instagramDemo
//
//  Created by Omry Dabush on 26/04/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit

struct User {
    let username : String
    let profileImageURL : String
    
    init(dictionary : [String : Any]) {
        username = dictionary["Username"] as? String ?? ""
        profileImageURL = dictionary["profile_image_URL"] as? String ?? ""
    }
}
