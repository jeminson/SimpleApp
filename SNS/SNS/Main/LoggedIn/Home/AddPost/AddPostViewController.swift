//
//  AddPostViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/27/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
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
        print("post")
    }
    
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "unwindSegue", sender: self)
        }
    }
    
    @IBAction func imgSelectBtn(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        
        if imagePicker.sourceType == .camera {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true, completion: nil)
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
