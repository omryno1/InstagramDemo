//
//  CameraController.swift
//  instagramDemo
//
//  Created by Omry Dabush on 09/01/2018.
//  Copyright © 2018 Omry Dabush. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate{
	
	let captureSession = AVCaptureSession()
	let output = AVCapturePhotoOutput()
	let previewLayer = AVCaptureVideoPreviewLayer()
	var isCaptureSessionConfigured = false
	
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
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.previewLayer.cornerRadius = 10
		if #available(iOS 11.0, *) {
			self.previewLayer.frame = CGRect(x: 0, y: view.safeAreaInsets.top , width: view.frame.width, height: view.frame.width * (4/3))
		} else {
			self.previewLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * (4/3))
		}
		self.view.layoutSubviews()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if (isCaptureSessionConfigured) {
			if (!self.captureSession.isRunning) {
				self.captureSession.startRunning()
			}
		}else {
			Shared.shared().checkCameraAuthorization({ (authorized) in
				guard authorized else {
					print("Permission to use camera denied.")
					return
				}
				DispatchQueue.global().async {
					self.setupCaptureSession({ (success) in
						guard success else { return }
						DispatchQueue.main.async {
							//4. Setup Output preview
							
							self.previewLayer.videoGravity = .resizeAspectFill
							self.previewLayer.session = self.captureSession
							
							self.isCaptureSessionConfigured = true
							self.captureSession.startRunning()
						}
					})
				}
			})
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if self.captureSession.isRunning {
			self.captureSession.startRunning()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupHUD()
	
	}
	
	@objc func handleDismiss() {
		dismiss(animated: true, completion: nil)
	}
	@objc func handleCapture() {
		print("Capture Image")

		let captureSettings = AVCapturePhotoSettings()
		captureSettings.flashMode = .auto
		captureSettings.isHighResolutionPhotoEnabled = true
		captureSettings.isAutoStillImageStabilizationEnabled = true
		
		let previewFormatType = NSNumber(value: kCVPixelFormatType_32BGRA)
		if captureSettings.availablePreviewPhotoPixelFormatTypes.contains(OSType(truncating: previewFormatType)) {
			captureSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String : 	previewFormatType]
			self.output.capturePhoto(with: captureSettings, delegate: self)
		}
	}
	
	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
		
		let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
		
		let previewImage = UIImage(data: imageData!)
		
		//TODO: need to stop the CaptureSession while displaying the image captured
//		let previewImageView = UIImageView(image: previewImage)
		
		let containerView = PreviewPhotoContainerView(frame: view.frame)
		containerView.previewImageView.image = previewImage
		view.addSubview(containerView)
		if #available(iOS 11.0, *) {
			containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
		} else {
				containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
		}
		
		print("Finish processing photo sample buffer...")
	}
	
	fileprivate func setupCaptureSession(_ completionHandler: ((_ success: Bool)-> Void)) {
		
		var success = false
		defer { completionHandler(success) } // Ensure all exit paths call completion handler.
		
		//1. Setup Inputs
		let captureDevice = defaultDevice()
		do {
			let input = try AVCaptureDeviceInput(device: captureDevice)
			if captureSession.canAddInput(input) {
				captureSession.addInput(input)
			}
		}catch let err {
			print("Unable to obtain video input for default camera. :  \(err)")
		}
		
		//2. Setup Outputs
		self.output.isHighResolutionCaptureEnabled = true
		self.output.isLivePhotoCaptureEnabled = output.isLivePhotoCaptureSupported
		if captureSession.canAddOutput(output){
			captureSession.addOutput(output)
		}
		
		//3. Configuring the session
		self.captureSession.beginConfiguration()
		self.captureSession.sessionPreset = .photo
		self.captureSession.commitConfiguration()
		
		success = true
	}
	
	func defaultDevice() -> AVCaptureDevice {
		if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
			return device // use dual camera on supported devices
		} else if let device = AVCaptureDevice.default( .builtInWideAngleCamera,for: .video, position: .back) {
			return device // use default back facing camera otherwise
		} else {
			fatalError("All supported devices are expected to have at least one of the queried capture devices.")
		}
	}
	
	fileprivate func setupHUD() {
		view.layer.addSublayer(self.previewLayer)
		
		view.addSubview(dismissButton)
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
