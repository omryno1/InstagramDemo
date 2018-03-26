//
//  Protocols.swift
//  instagramDemo
//
//  Created by Omry Dabush on 31/01/2018.
//  Copyright © 2018 Omry Dabush. All rights reserved.
//

import Foundation

protocol HomePostCellDelegate {
	func didTapComment(post: Post)
	func didLike(for cell: HomePostCell)
}
