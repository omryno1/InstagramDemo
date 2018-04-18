//
//  Shared.swift
//  instagramDemo
//
//  Created by Omry Dabush on 23/12/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import Photos

class Shared {
	
	var currenUser = Auth.auth().currentUser
	let cellID = "cellID"
	let homePostCellID = "homePostCellId"
	var allPosts = [Post]()
	
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
	
	//MARK: - AV Authurizations
	
	func checkCameraAuthorization(_ completionHandler: @escaping ((_ authorized: Bool) -> Void)) {
		switch AVCaptureDevice.authorizationStatus(for: .video) {
		case .authorized:
			//The user has previously granted access to the camera.
			completionHandler(true)
			
		case .notDetermined:
			// The user has not yet been presented with the option to grant video access so request access.
			AVCaptureDevice.requestAccess(for: .video, completionHandler: { success in
				completionHandler(success)
			})
			
		case .denied:
			// The user has previously denied access.
			completionHandler(false)
			
		case .restricted:
			// The user doesn't have the authority to request access e.g. parental restriction.
			completionHandler(false)
		}
	}
	
	//MARK: - Photos Authorizations
	
	func checkPhotoLibraryAuthorization(_ completionHandler: @escaping ((_ authorized: Bool) -> Void)) {
		switch PHPhotoLibrary.authorizationStatus() {
		case .authorized:
			// The user has previously granted access to the photo library.
			completionHandler(true)
			
		case .notDetermined:
			// The user has not yet been presented with the option to grant photo library access so request access.
			PHPhotoLibrary.requestAuthorization({ status in
				completionHandler((status == .authorized))
			})
			
		case .denied:
			// The user has previously denied access.
			completionHandler(false)
			
		case .restricted:
			// The user doesn't have the authority to request access e.g. parental restriction.
			completionHandler(false)
		}
	}
}
