//
//  ForgotPasswordViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/20/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import TWMessageBarManager


class ForgotPasswordViewController: MRKBaseViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

            title = "Forgot Password"
    }
    
    @IBAction func submitActionButton(_ sender: UIButton) {
    

        FirebaseAPIHandler.sharedInstance.resetPassword(email: usernameTextField.text!) { (error) in
            if error == nil {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Reset", description: "Sent to your email", type: .info)
            } else {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)
            }
            
        }
        
        
    }
    

}
