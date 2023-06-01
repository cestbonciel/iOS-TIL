//
//  ViewController.swift
//  CameraPhotoLibrary
//
//  Created by Seohyun Kim on 2023/06/02.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

	@IBOutlet weak var imgView: UIImageView!
	let imagePicker: UIImagePickerController! = UIImagePickerController()
	var caputureImage: UIImage!
	var videoURL: URL!
	var flagImageSave = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	//MARK: Action For button
	@IBAction func btnCaptureImageFromCamera(_ sender: UIButton) {
		if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
			flagImageSave = true
			
			imagePicker.delegate = self
			imagePicker.sourceType = .camera
			imagePicker.mediaTypes = (UTType.image as! CFString) as! [String]
			imagePicker.allowsEditing = false
			
			present(imagePicker, animated: true, completion: nil)
		} else {
			myAlert("Camera inaccessable", message: "Application cannot access the camera.")
		}
	}
	
	@IBAction func btnLoadImageFromLibrary(_ sender: UIButton) {
		if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
			flagImageSave = false
			
			imagePicker.delegate = self
			imagePicker.sourceType = .photoLibrary
			imagePicker.mediaTypes = (UTType.image as! CFString) as! [String]
			imagePicker.allowsEditing = true
			
			present(imagePicker, animated: true, completion: nil)
		} else {
			myAlert("Photo album inaccessable", message: "Application cannot access the photo album")
		}
	}
	
	@IBAction func btnRecordVideoFromCamera(_ sender: UIButton) {
		if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
			flagImageSave = true
			
			imagePicker.delegate = self
			imagePicker.sourceType = .camera
			imagePicker.mediaTypes = (UTType.movie as! CFString) as! [String]
			imagePicker.allowsEditing = false
			
			present(imagePicker, animated: true, completion: nil)
		} else {
			myAlert("Camera inaccessable", message: "Application cannot access the camera.")
		}
	}
	
	@IBAction func btnLoadVideoFromLibrary(_ sender: UIButton) {
		if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
			flagImageSave = false
			
			imagePicker.delegate = self
			imagePicker.sourceType = .photoLibrary
			imagePicker.mediaTypes = (UTType.movie as! CFString) as! [String]
			imagePicker.allowsEditing = false
			
			present(imagePicker, animated: true, completion: nil)
		} else {
			myAlert("Photo album inaccessable", message: "Application cannot access the photo album.")
		}
	}
	
	// MARK: Delegate3wses
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
		
		if mediaType.isEqual(to: (UTType.image as! NSString) as String) {
			caputureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
			
			if flagImageSave {
				UIImageWriteToSavedPhotosAlbum(caputureImage, self, nil, nil)
			}
			
			imgView.image = caputureImage
		} else if mediaType.isEqual(to: (UTType.movie as! NSString) as String) {
			if flagImageSave {
				videoURL = (info[UIImagePickerController.InfoKey.mediaURL] as! URL)
				
				UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, self, nil, nil)
			}
		}
		
		self.dismiss(animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss(animated: true, completion: nil)
	}
	
	func myAlert(_ title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
		let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
	}
}

