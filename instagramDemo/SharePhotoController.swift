//
//  SharePhotoController.swift
//  instagramDemo
//
//  Created by Omry Dabush on 21/04/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController, UITextViewDelegate {
    
    let placeHolder = "What's your photo all about..."
    
    var selectedImage : UIImage? {
        didSet {
            imageView.image = selectedImage
        }
    }
    
    let containerView : UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
       return cv
    }()
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .red
        return iv
    }()
    
    let textView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = UIColor.lightGray
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.rgb(red: 66, green: 188, blue: 244)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        textView.delegate = self
        
        view.addSubview(containerView)
        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 100)
        
        setupImageAndTextViews()
    }
    
    fileprivate func setupImageAndTextViews() {
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, topPadding: 8, leftPadding: 8, bottomPadding: 8, rightPadding: 0, width: 84, height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topPadding: 8, leftPadding: 8, bottomPadding: 8, rightPadding: 8, width: 0, height: 0)
        
        textView.text = placeHolder
    }
    
    @objc func handleShare(){
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        guard let caption = textView.text else { return }
        guard let image = imageView.image else { return }
        guard let data = UIImageJPEGRepresentation(image, 0.5) else  { return }
        
        let fileName = NSUUID().uuidString
        
        Storage.storage().reference().child("Posts").child(fileName).putData(data, metadata: nil) { (metadata, err) in
            if let err = err {
                print ("Failed uploading to FireBase storage", err)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            
            guard let imageURL = metadata?.downloadURL()?.absoluteString else { return }
            print ("Successfully uploaded to Firebase storage")
            self.handleUploadToFIRDataBase(imageURL: imageURL, caption: caption)
        }
//        put(data, metadata: nil) { (metadata, err) in
//            if let err = err {
//                print ("Failed uploading to FireBase storage", err)
//                self.navigationItem.rightBarButtonItem?.isEnabled = true
//                return
//            }
//
//            guard let imageURL = metadata?.downloadURL()?.absoluteString else { return }
//            print ("Successfully uploaded to Firebase storage")
//            self.handleUploadToFIRDataBase(imageURL: imageURL, caption: caption)
//        }
        
    }
    
    fileprivate func handleUploadToFIRDataBase(imageURL : String, caption : String) {
        
        guard let uid = Shared.shared().currenUser?.uid else { return }
        guard let postImage = selectedImage else { return }
        
        let userPostsRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostsRef.childByAutoId()
        
        let values = ["imageURL": imageURL, "Caption" : caption, "ImageHeight" : postImage.size.height, "imageWidth" : postImage.size.width, "creationDate": Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to updata FireBase DataBase", err)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            
            print("Successfully uploaded to FireBase DataBase")
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        textView.textColor = UIColor.lightGray
        textView.text = placeHolder
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }else {
            textView.endEditing(true)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
