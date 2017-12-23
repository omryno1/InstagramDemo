//
//  AddPhotoController.swift
//  instagramDemo
//
//  Created by Omry Dabush on 18/04/2017.
//  Copyright © 2017 Omry Dabush. All rights reserved.
//

import UIKit
import Photos

class AddPhotoController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let headerID = "headerid"
    let cellID = "cellid"
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedImage : UIImage?
    var currentImageIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        setupNavigationButtons()
        
        collectionView?.delegate = self
        collectionView?.register(PhotoPreviewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
        collectionView?.register(PhotoThumbnail.self, forCellWithReuseIdentifier: cellID)
        
        fetchPhotos()
    }
    
    fileprivate func fetchPhotos(){

        let allPhotos = PHAsset.fetchAssets(with: .image, options: assestsFetchOptions())
        DispatchQueue.global().async {
            
            allPhotos.enumerateObjects(using: { (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let size = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                        
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                })
            })
        }
    }
    
    func assestsFetchOptions() -> PHFetchOptions{
        let assetsOptions = PHFetchOptions()
        assetsOptions.fetchLimit = 15
        let sortDescriptor = NSSortDescriptor(key:"creationDate", ascending: false)
        assetsOptions.sortDescriptors = [sortDescriptor]
        return assetsOptions
    }
    
    //**Adding the header***
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! PhotoPreviewHeader
        
        header.imagePreview.image = selectedImage
        
        if let selectedImage = selectedImage {
            if let imageIndex = images.index(of: selectedImage) {
                let selectedAsset = assets[imageIndex]
                let targetSize = CGSize(width: 600, height: 600)
                let imageManager = PHImageManager.default()
                
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil, resultHandler: { (image, info) in
                    if let image = image {
                        header.imagePreview.image = image
                        self.selectedImage = image
                    }
                })
                
            }
        }
        
        
        return header
    }
    
    //**Adding the collection view
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (view.frame.width - 3) / 4
        
        return CGSize(width: cellSize, height: cellSize)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoThumbnail
        
        cell.imageThumbnail.image = images[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentImageIndexPath != indexPath {
            self.currentImageIndexPath = indexPath
            self.selectedImage = images[indexPath.item]
            self.collectionView?.reloadData()
        }
    }
    
    //**End of CollectionView**
    
    fileprivate func setupNavigationButtons(){
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButton))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNextButton))
        
    }
    
    @objc func handleCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
   	@objc func handleNextButton() {
        let sharePhotoController = SharePhotoController()
        sharePhotoController.selectedImage = selectedImage
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
