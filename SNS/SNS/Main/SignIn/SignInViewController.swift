//
//  ViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/20/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import TWMessageBarManager

class SignInViewController: MRKBaseViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }

    @IBAction func signUpActionButton(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    @IBAction func signInActionButton(_ sender: UIButton) {
        FirebaseAPIHandler.sharedInstance.signIn(email: usernameTextField.text!, passwd: passwordTextField.text!) { (result, error) in
            if error == nil {
                
                
                DispatchQueue.main.async {
                    
                    TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success", description: "Successfully logged in", type: .success)
                    self.performSegue(withIdentifier: "LoggedInTabBarController", sender: nil)
                }
                
                print("logged in")
            } else {
                
                DispatchQueue.main.async {
                    TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)
                }

                print("error")
            }
        }
    }
    @IBAction func forgotPasswordActionButton(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

