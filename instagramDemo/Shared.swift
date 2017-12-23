//
//  Shared.swift
//  instagramDemo
//
//  Created by Omry Dabush on 23/12/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit
import Firebase

class Shared {
	
	var currenUser = Auth.auth().currentUser
	
	private static var sharedInstance : Shared?
	
	class func shared() -> Shared {
		guard let uwShared = sharedInstance  else {
			sharedInstance = Shared()
			return sharedInstance!
		}
		return uwShared
	}
	class func destroy(){
		sharedInstance = nil
	}
	
	private init() {
	}
	
}
