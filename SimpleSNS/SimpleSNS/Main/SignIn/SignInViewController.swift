//
//  ViewController.swift
//  SimpleSNS
//
//  Created by Je Min Son on 11/29/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import SVProgressHUD
import TWMessageBarManager
import TextFieldEffects
import FirebaseMessaging

class SignInViewController: MRKBaseViewController {

    @IBOutlet weak var signInBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var userIdTextField: YoshikoTextField!
    @IBOutlet weak var passwordTextField: YoshikoTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapper = UITapGestureRecognizer(target: self, action:#selector(hideKeyboard))
        tapper.cancelsTouchesInView = false
        view.addGestureRecognizer(tapper)
        
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }

    
    @IBAction func actionBtn(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            switch sender.tag {
            case 1:
                self.performSegue(withIdentifier: "SignUpViewController", sender: nil)
            case 2:
                self.performSegue(withIdentifier: "ForgotPasswordViewController", sender: nil)
            case 3:
                SVProgressHUD.show(withStatus: "Logging In")
                FirebaseAPIHandler.sharedInstance.signIn(emailId: self.userIdTextField.text!, passwd: self.passwordTextField.text!) { (result, error) in
  
                    if error == nil {
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            Messaging.messaging().subscribe(toTopic: result.uid)
                            TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success", description: "Successfully logged in", type: .success)
                            self.performSegue(withIdentifier: "LoggedInTabBarController", sender: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)
                        }
                    }
                }
            default:
                break
            }
        }
    }
    
}

// MARK: - TextField Delegate
extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
