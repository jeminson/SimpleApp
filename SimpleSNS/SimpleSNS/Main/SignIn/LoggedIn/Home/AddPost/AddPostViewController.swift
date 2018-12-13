//
//  AddPostViewController.swift
//  SimpleSNS
//
//  Created by Je Min Son on 11/30/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import SVProgressHUD
import TWMessageBarManager
import UITextView_Placeholder

class AddPostViewController: MRKBaseViewController {
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var contextTextView: UITextView!
    @IBOutlet weak var selectPostImg: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Post"
        
        contextTextView.placeholder = "Write a caption..."
        
        imagePicker.delegate = self
        
        self.navBar.setBackgroundImage(UIImage(), for: .default)
        self.navBar.shadowImage = UIImage()
        self.navBar.isTranslucent = true
    }
    
    @IBAction func postBarButton(_ sender: UIBarButtonItem) {
        
        SVProgressHUD.show(withStatus: "Loading...")
        FirebaseAPIHandler.sharedInstance.addNewPost(postString: contextTextView.text, postImg: selectPostImg.image!) { (error) in
            DispatchQueue.main.async{
                SVProgressHUD.dismiss()
            }
            if error == nil{
                DispatchQueue.main.async {
                    TWMessageBarManager.sharedInstance().showMessage(withTitle: "Sucess", description: "Successfully posted", type: .success)
                    self.dismiss(animated: true)
                }
            }else{
                DispatchQueue.main.async {
                    TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)
                }
            }
        }
    }
    
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "unwindSegue", sender: self)
        }
    }
    
    @IBAction func imgSelectBtn(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        
        SVProgressHUD.show(withStatus: "Loading images...")
        if imagePicker.sourceType == .camera {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
    }
    
}

extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectPostImg.image = image
        }
        
        dismiss(animated: true, completion: nil)
    } // End imagePickerController
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    } // End imagePickerControllerDidCancel
}
