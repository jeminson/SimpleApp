//
//  ForgotPasswordViewController.swift
//  Demo
//
//  Created by Je Min Son on 11/20/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import Firebase
import TWMessageBarManager

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailIDTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "FORGOT PASSWORD"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    @IBAction func submitActionButton(_ sender: UIButton) {
        
        if emailIDTextField.text != nil {
            Auth.auth().sendPasswordReset(withEmail: self.emailIDTextField.text!) { (error) in
                if error == nil {
                    TWMessageBarManager.sharedInstance().showMessage(withTitle: "Reset", description: "Sent to the email", type: .info)
                    

                } else {
                    TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)

                }
            }
        }

    }
    
}
