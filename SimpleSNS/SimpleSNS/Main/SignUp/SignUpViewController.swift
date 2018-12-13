//
//  SignUpViewController.swift
//  SimpleSNS
//
//  Created by Je Min Son on 11/29/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import SVProgressHUD
import TWMessageBarManager
import CoreLocation

class SignUpViewController: MRKBaseViewController {
    
    @IBOutlet weak var profileImgView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    let locationManager = CLLocationManager()
    let signUpDispatchGroup = DispatchGroup()
    
    var userInfo : UserModel?
    var placeHolderArray = ["First Name", "Last Name", "Email ID", "Address", "Phone Number", "Password"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign Up"
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        imagePicker.delegate = self
        
        if userInfo == nil {
            userInfo = UserModel()
        }
    }
    
    // MARK : - IBAction
    @IBAction func selectImgActionBtn(_ sender: UIButton) {
        
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
    } // End selectImgActionBtn
    
    @IBAction func submitActionBtn(_ sender: UIButton) {
        
        view.endEditing(true)
        
        signUpDispatchGroup.enter() // enter code
        locationManager.requestLocation()
        
        signUpDispatchGroup.notify(queue: .main) {
            SVProgressHUD.show(withStatus: "Registering")
            if let userObj = self.userInfo {
                if let _ = userObj.firstName, let _ = userObj.lastName, let _ = userObj.emailId, let _ = userObj.address, let _ = userObj.phoneNumber, let _ = userObj.password, let _ = userObj.latitude, let _ = userObj.longitude {
                    
                    FirebaseAPIHandler.sharedInstance.signUpNewUser(userInfo: userObj, userImg: self.profileImgView.image ?? UIImage(named: "default_user")!) { (result, error) in
                        
                        if error == nil {
                            DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                                                                
                                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success", description: "Successfully registered for new user", type: .success)
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
                    print("Error")
                }
            }
        }// notify
    } // End submitActionBtn
    
    
    
} // End SignUpViewController class


extension SignUpViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userInfo?.latitude = String(location.coordinate.latitude)
            userInfo?.longitude = String(location.coordinate.longitude)
            signUpDispatchGroup.leave()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK : - ImagePicker Delegate
extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImgView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    } // End imagePickerController
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    } // End imagePickerControllerDidCancel
}


// MARK: - TextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            userInfo?.firstName = textField.text
        case 1:
            userInfo?.lastName = textField.text
        case 2:
            userInfo?.emailId = textField.text
        case 3:
            userInfo?.address = textField.text
        case 4:
            userInfo?.phoneNumber = textField.text
        case 5:
            userInfo?.password = textField.text
        default:
            break
        }
    }
}

// MARK: - TableView DataSource
extension SignUpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeHolderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpTableViewCell") as! SignUpTableViewCell
        
        cell.userInfoTextField.tag = indexPath.row
        cell.userInfoTextField.delegate = self
        cell.userInfoTextField.placeholder = placeHolderArray[indexPath.row]
        
        switch indexPath.row {
        case 0:
            cell.userInfoTextField.text = userInfo?.firstName
        case 1:
            cell.userInfoTextField.text = userInfo?.lastName
        case 2:
            cell.userInfoTextField.text = userInfo?.emailId
            cell.userInfoTextField.keyboardType = UIKeyboardType.emailAddress
        case 3:
            cell.userInfoTextField.text = userInfo?.address
        case 4:
            cell.userInfoTextField.text = userInfo?.phoneNumber
            cell.userInfoTextField.keyboardType = UIKeyboardType.phonePad
        case 5:
            cell.userInfoTextField.text = userInfo?.password
            cell.userInfoTextField.isSecureTextEntry = true
        default:
            break
        }
        
        return cell
    }
    
    
}
