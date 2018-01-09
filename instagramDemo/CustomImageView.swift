//
//  CustomImageView.swift
//  instagramDemo
//
//  Created by Omry Dabush on 02/05/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit

var imageCache = [String : UIImage]()

class CustomImageView : UIImageView {
    
    var lastImageUrlLoaded : String?
    
    func loadImage (ImageURL : String) {
        lastImageUrlLoaded = ImageURL
		
		self.image = nil
        
        if let cachedImage = imageCache[ImageURL] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: ImageURL) else {return}
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let err = error {
                print("Failed to load url ", err)
                return
            }
            
            if url.absoluteString != self.lastImageUrlLoaded {
                return
            }
            
            guard let imageData = data else {return}
            let imagePhoto = UIImage(data: imageData)
            imageCache[url.absoluteString] = imagePhoto
            
            DispatchQueue.main.async {
                self.image = imagePhoto
            }
            
        }).resume()
    }
    
}
