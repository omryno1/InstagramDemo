//
//  Extentions.swift
//  instagramDemo
//
//  Created by Omry Dabush on 13/04/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
	
	static func mainBlue() -> UIColor {
		return UIColor.rgb(red: 17, green: 154, blue: 237)
	}
    
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? , left: NSLayoutXAxisAnchor? , bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, topPadding: CGFloat, leftPadding: CGFloat, bottomPadding: CGFloat, rightPadding: CGFloat, width: CGFloat, height: CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topPadding).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: leftPadding).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -bottomPadding).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -rightPadding).isActive = true
        }
        
        if width != 0{
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0{
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension Date {
	func timeAgoDisplay() -> String {
		let secondsAgo = Int(Date().timeIntervalSince(self))
		
		let minute = 60
		let hour = 60 * minute
		let day = 24 * hour
		let week = 7 * day
		let month = 4 * week
		
		let quotient: Int
		let unit: String
		if secondsAgo < minute {
			quotient = secondsAgo
			unit = "second"
		} else if secondsAgo < hour {
			quotient = secondsAgo / minute
			unit = "min"
		} else if secondsAgo < day {
			quotient = secondsAgo / hour
			unit = "hour"
		} else if secondsAgo < week {
			quotient = secondsAgo / day
			unit = "day"
		} else if secondsAgo < month {
			quotient = secondsAgo / week
			unit = "week"
		} else {
			quotient = secondsAgo / month
			unit = "month"
		}
		
		return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
		
	}
}
