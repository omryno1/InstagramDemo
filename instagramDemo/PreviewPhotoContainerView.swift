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
	
	let previewImageView : UIImageView = {
		let iv = UIImageView()
		iv.contentMode = .scaleAspectFit
		iv.layer.cornerRadius = 10
		iv.layer.masksToBounds = true
		return iv
	}()
	
	let dismissButton : UIButton = {
		let bt = UIButton(type: .system)
		bt.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
		bt.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
		return bt
	}()
	
	@objc func handleCancel(){
		self.removeFromSuperview()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .black
		
		addSubview(previewImageView)
		previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: frame.width, height: frame.width * (4/3))
		
		addSubview(dismissButton)
		dismissButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, topPadding: 40, leftPadding: 0, bottomPadding: 0, rightPadding: 12, width: 50, height: 50)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
