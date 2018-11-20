//
//  ViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/20/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit

class SignInViewController: MRKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }

    @IBAction func signUpActionButton(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    @IBAction func signInActionButton(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "LoggedInViewController") as? LoggedInViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    @IBAction func forgotPasswordActionButton(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

