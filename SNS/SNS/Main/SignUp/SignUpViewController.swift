//
//  SignUpViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/20/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import Firebase

protocol DetailUserInfo {
    func saveUserInfo(object: UserInfo, editUserInfo: Bool)
}

class SignUpViewController: MRKBaseViewController {
    
    var userInfo : UserInfo?
    var delegate : DetailUserInfo?
    var isEdit: Bool = false

    var placeHolderArray : [String] = ["First Name", "Last Name", "Email ID", "Address", "Phone Number", "Password"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign Up"
        
        if userInfo == nil {
            userInfo = UserInfo()
        }
    }
    
    
    
    @IBAction func submitActionButton(_ sender: UIButton) {
        
        view.endEditing(true)
        
        if let obj = userInfo {
            if let fName = obj.firstName, let lName = obj.lastName, let emailString = obj.emailId, let add = obj.address, let phoneNum = obj.phoneNumber, let pwString = obj.password {
                delegate?.saveUserInfo(object: obj, editUserInfo: isEdit)
                
                
//                FirebaseAPIHandler.sharedInstance.signUp(email: emailString, passwd: pwString, firstName: fName, lastName: lName, address: add, phoneNumber: phoneNum)

            }
        }
        
        
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 4 {
            textField.keyboardType = .numbersAndPunctuation
        } else {
            textField.keyboardType = .default
        }
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

extension SignUpViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeHolderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpTableViewCell") as! SignUpTableViewCell
        
        cell.signUpTextField.placeholder = placeHolderArray[indexPath.row]

        cell.signUpTextField.delegate = self
        cell.signUpTextField.tag = indexPath.row
        
        switch indexPath.row {
        case 0:
            cell.signUpTextField.text = userInfo?.firstName
        case 1:
            cell.signUpTextField.text = userInfo?.lastName
        case 2:
            cell.signUpTextField.text = userInfo?.emailId
        case 3:
            cell.signUpTextField.text = userInfo?.address
        case 4:
            cell.signUpTextField.text = userInfo?.phoneNumber
        case 5:
            cell.signUpTextField.text = userInfo?.password
            cell.signUpTextField.isSecureTextEntry = true
        default:
            break
        }

        return cell
    }
    
    
}
