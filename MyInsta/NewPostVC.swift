//
//  NewPostVC.swift
//  MyInsta
//
//  Created by Henry Guerra on 2/11/19.
//  Copyright © 2019 Henry Guerra. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class NewPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // public instance vars
    var window: UIWindow?
    var postImage: UIImage! = nil
    
    // public outlets
    @IBOutlet weak var uploadImageField: UIImageView!
    
    @IBOutlet weak var uploadCaptionField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentImagePicker()
    }
    
    // Public Actions
    @IBAction func cancelUploadPost(_ sender: Any) {
        clear()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "HomeVCID") // this is not working, trying something else below
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func sharePost(_ sender: Any) {
        if postImage == nil {
            presentAlert(msg: "No image chosen", description: "Bruh.. select an image b4 sharing duh")
        } else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            //post img to parse
            print("img posting to parse...")
            Post.postUserImage(image: postImage, withCaption: uploadCaptionField.text, withCompletion: { (success: Bool, error: Error?) in
                if success {
                    print("successfully loaded image")
                } else {
                    print("oh no! error occurred while posting image")
                }
                MBProgressHUD.hide(for: self.view, animated: true)
                self.clear()
            })
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        _ = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        self.postImage = editedImage
        
        uploadImageField.image = editedImage
        print("image dismissed")
        dismiss(animated: true, completion: nil)
    }
    
    
    /* PRIVATE METHODS */
    private func presentImagePicker() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        // checking if camera access is possible
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("camera is available")
            vc.sourceType = .camera
        } else {
            print("camera not available")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    private func clear() {
        uploadImageField.image = UIImage(named: "image_placeholder")
        uploadCaptionField.text = ""
        postImage = nil
    }
    
    private func presentAlert(msg: String, description: String) {
        let alertController = UIAlertController(title: msg, message: description, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    // Resize image to store to db
    private func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x:0, y:0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIView.ContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
}
