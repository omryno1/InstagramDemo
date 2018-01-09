//
//  CameraController.swift
//  instagramDemo
//
//  Created by Omry Dabush on 09/01/2018.
//  Copyright © 2018 Omry Dabush. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
	
	let dismissButton: UIButton = {
		let bt = UIButton(type: .system)
		bt.setImage(#imageLiteral(resourceName: "right_arrow_shadow"), for: .normal)
		bt.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
		return bt
	}()
	
	let captureButton: UIButton = {
		let bt = UIButton(type: .system)
		bt.setImage(#imageLiteral(resourceName: "capture_photo"), for: .normal)
		bt.addTarget(self, action: #selector(handleCapture), for: .touchUpInside)
		return bt
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupCaptureSession()
		setupHUD()
	
	}
	
	@objc func handleDismiss() {
		dismiss(animated: true, completion: nil)
	}
	@objc func handleCapture() {
		print("Capture Image")
	}
	
	fileprivate func setupCaptureSession() {
		let captureSession = AVCaptureSession()
		guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
		
		//1. Setup Inputs
		do {
			let input = try AVCaptureDeviceInput(device: captureDevice)
			if captureSession.canAddInput(input) {
				captureSession.addInput(input)
			}
		}catch let err {
			print("Failed to get device input ", err)
		}
		//2. Setup Outputs
		let output = AVCapturePhotoOutput()
		if captureSession.canAddOutput(output){
			captureSession.addOutput(output)
		}
		
		//3. Setup Output preview
		let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		previewLayer.frame = CGRect(x: 0, y: 44, width: view.frame.width, height: view.frame.height - 88)
		previewLayer.videoGravity = .resizeAspectFill
		view.layer.addSublayer(previewLayer)
		
		
		captureSession.startRunning()
	}
	
	fileprivate func setupHUD() {
		view.addSubview(dismissButton)
		view.addSubview(captureButton)
		if #available(iOS 11.0, *) {
			dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil , right: view.rightAnchor, topPadding: 12, leftPadding: 0, bottomPadding: 0, rightPadding: 12, width: 50, height: 50)
		}else {
			dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topPadding: 12, leftPadding: 0, bottomPadding: 0, rightPadding: 12, width: 50, height: 50)
		}
		
		view.addSubview(captureButton)
		if #available(iOS 11.0, *) {
			captureButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topPadding: 0, leftPadding: 0, bottomPadding: 34, rightPadding: 0, width: 80, height: 80)
		}else {
			captureButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, topPadding: 0, leftPadding: 0, bottomPadding: 24, rightPadding: 0, width: 80, height: 80)
		}
		captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		
	}
}
