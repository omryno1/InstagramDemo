//
//  PreviewPhotoContainerView.swift
//  instagramDemo
//
//  Created by Omry Dabush on 24/01/2018.
//  Copyright © 2018 Omry Dabush. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView : UIView {
	
	var imageData : Data?
	
	let previewImageView : UIImageView = {
		let iv = UIImageView()
		iv.contentMode = .scaleAspectFit
		iv.layer.cornerRadius = 10
		iv.layer.masksToBounds = true
		return iv
	}()
	
	let dismissButton : UIButton = {
		let bt = UIButton(type: .system)
		bt.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
		bt.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
		return bt
	}()
	
	let saveButton : UIButton = {
		let bt = UIButton(type: .system)
		bt.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
		bt.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
		return bt
	}()
	
	@objc func handleCancel(){
		self.removeFromSuperview()
	}
	
	@objc func handleSave() {
		print ("saving the image")
		
		PHPhotoLibrary.requestAuthorization({ (status) in
			if (status == .authorized) {
				//TODO: UIImageView must be used from the main thread Only
				guard let data = self.imageData else { return }
				
				PHPhotoLibrary.shared().performChanges({
					let option = PHAssetResourceCreationOptions()
					let creationRequest = PHAssetCreationRequest.forAsset()
					creationRequest.addResource(with: .photo, data: data, options: option)

				}, completionHandler: { (_, error) in
					if let err = error {
						print("Error occurered while saving photo to photo library: \(err)")
						return
					}
					
					print("Successfully saved image to librery")
					DispatchQueue.main.async {
						self.saveImageAnimation()
					}
					
				})
			}
		})
	}
	@objc func saveImageAnimation(){
		let savedLabel = UILabel()
		savedLabel.text = "Saved Successfully"
		savedLabel.font = UIFont.systemFont(ofSize: 18)
		savedLabel.textColor = .white
		savedLabel.numberOfLines = 0
		savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
		savedLabel.textAlignment = .center
		savedLabel.alpha = 1
		savedLabel.layer.cornerRadius = 10
		savedLabel.layer.masksToBounds = true
		
		savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
		savedLabel.center = self.previewImageView.center
		
		self.addSubview(savedLabel)

		savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
		
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
			
			savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
			
		}, completion: { (_) in
			UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
				
				savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
				savedLabel.alpha = 0
				
			}, completion: { (_) in
				savedLabel.removeFromSuperview()
			})
		})
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .black
		
		addSubview(previewImageView)
		previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: frame.width, height: frame.width * (4/3))
		
		addSubview(dismissButton)
		dismissButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topPadding: 12, leftPadding: 12, bottomPadding: 0, rightPadding: 0, width: 50, height: 50)
		
		addSubview(saveButton)
		saveButton.anchor(top: nil, left: leftAnchor, bottom: previewImageView.bottomAnchor, right: nil
		, topPadding: 0, leftPadding: 12, bottomPadding: 12, rightPadding: 0, width: 50, height: 50)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
