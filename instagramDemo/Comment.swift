//
//  Comment.swift
//  instagramDemo
//
//  Created by Omry Dabush on 04/02/2018.
//  Copyright © 2018 Omry Dabush. All rights reserved.
//

import Foundation

struct Comment {
	
	let uid : String
	let creationDate : Date
	let commentText : String
	
	init(dictionary: [String: Any]) {
		self.commentText = dictionary["commentText"] as? String ?? ""
		self.uid = dictionary["uid"] as? String ?? ""
		let timeSince1970 = dictionary["creationDate"] as? Double ?? 0
		self.creationDate = Date(timeIntervalSince1970: timeSince1970)
		
	}
}

