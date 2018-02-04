//
//  CustomSearchTextField.swift
//  instagramDemo
//
//  Created by Omry Dabush on 01/02/2018.
//  Copyright © 2018 Omry Dabush. All rights reserved.
//

import UIKit

class CustomSearchTextField: UITextField {
	
	//Allows adding an insets to UITestField
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds,
									 UIEdgeInsetsMake(0, 15, 0, 15))
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 15, 0, 15))
	}
	
	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds,
									 UIEdgeInsetsMake(0, 15, 0, 15))
	}
}
