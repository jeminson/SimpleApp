//
//  EditProfileViewController.swift
//  SimpleSNS
//
//  Created by Je Min Son on 11/30/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import SVProgressHUD
import TWMessageBarManager

class EditProfileViewController: MRKBaseViewController {

    @IBOutlet weak var editProfileImgView: UIImageView!
    @IBOutlet weak var editProfileTableView: UITableView!
    
    let imagePicker = UIImagePickerController()

    var userInfoArray: UserModel?
    var placeHolderArray = ["First Name", "Last Name", "Address", "Phone Number"]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Profile"
        
        imagePicker.delegate = self

        if userInfoArray == nil {
            userInfoArray = UserModel()
        }
        
        fetchUser()
        fetchUserProfileImg()
    }
    
    func fetchUserProfileImg() {
        SVProgressHUD.show(withStatus: "Loading profile image")
        FirebaseAPIHandler.sharedInstance.fetchCurrentUserImage() { (image, error) in
            if error == nil {
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.editProfileImgView.image = image
                }
            }
        }
    }
    
    func fetchUser() {
        
        SVProgressHUD.show(withStatus: "Loading profile")
        FirebaseAPIHandler.sharedInstance.fetchCurrentUser() { (userData) in

            self.userInfoArray = userData
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.editProfileTableView.reloadData()
            }
        }
    }
    
    // MARK: - IBAction
    @IBAction func selectNewImageBtn(_ sender: UIButton) {
        SVProgressHUD.show(withStatus: "Loading images from library")
        imagePicker.allowsEditing = true
        
        if imagePicker.sourceType == .camera {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        DispatchQueue.main.async {
            self.present(self.imagePicker, animated: true, completion: nil)
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func saveBarBtn(_ sender: UIBarButtonItem) {
        SVProgressHUD.show(withStatus: "Updating")
        if let updateObj = self.userInfoArray {
            if let _ = updateObj.firstName, let _ = updateObj.lastName, let _ = updateObj.address, let _ = updateObj.phoneNumber {
                FirebaseAPIHandler.sharedInstance.updateUserInformation(updatedUserInfo: updateObj, updateProfileImg: self.editProfileImgView.image ?? UIImage(named: "")!) { (result, error) in
                    
                    if error == nil {
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success", description: "Successfully updated user profile", type: .success)
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)
                        }
                    }
                }
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
}

// MARK : - ImagePicker Delegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            editProfileImgView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    } // End imagePickerController
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    } // End imagePickerControllerDidCancel
}


// MARK: - TextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            userInfoArray?.firstName = textField.text
        case 1:
            userInfoArray?.lastName = textField.text
        case 2:
            userInfoArray?.address = textField.text
        case 3:
            userInfoArray?.phoneNumber = textField.text
        default:
            break
        }
    }
}


extension EditProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeHolderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileTableViewCell") as! EditProfileTableViewCell
        
        cell.editProfileTextField.tag = indexPath.row
        cell.editProfileTextField.delegate = self
        cell.editProfileTextField.placeholder = placeHolderArray[indexPath.row]
        
        switch indexPath.row {
        case 0:
            cell.editProfileTextField.text = userInfoArray?.firstName
        case 1:
            cell.editProfileTextField.text = userInfoArray?.lastName
        case 2:
            cell.editProfileTextField.text = userInfoArray?.address
        case 3:
            cell.editProfileTextField.text = userInfoArray?.phoneNumber
            cell.editProfileTextField.keyboardType = UIKeyboardType.phonePad
        default:
            break
        }
        
        return cell
    }
    
    
}
