//
//  Posts.swift
//  instagramDemo
//
//  Created by Omry Dabush on 26/04/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit

struct Post {
    let user : User
    let imageURL : String
    let caption : String
	let creatinDate : Date
    
    init(user : User, dictionary: [String : Any]) {
        self.user = user
        imageURL = dictionary["imageURL"] as? String ?? ""
        caption = dictionary["Caption"] as? String ?? ""
		let timeSince1970 = dictionary["creationDate"] as? Double ?? 0
		creatinDate = Date(timeIntervalSince1970: timeSince1970)
    }
}	
