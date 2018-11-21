//
//  ForgotPasswordViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/20/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: MRKBaseViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

            title = "Forgot Password"
    }
    
    
    @IBAction func submitActionButton(_ sender: UIButton) {
    
        if usernameTextField.text != nil {
            FirebaseAPIHandler.sharedInstance.resetPassword(email: usernameTextField.text!)
        }
        
        
    }
    

}
