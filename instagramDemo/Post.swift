//
//  Posts.swift
//  instagramDemo
//
//  Created by Omry Dabush on 26/04/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit

struct Post {
    let imageURL : String
    
    init(dictionary: [String : Any]) {
        imageURL = dictionary["imageURL"] as? String ?? ""
    }
}
