//
//  ForgotPasswordViewController.swift
//  SimpleSNS
//
//  Created by Je Min Son on 11/30/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import TWMessageBarManager
import TextFieldEffects

class ForgotPasswordViewController: MRKBaseViewController {

    @IBOutlet weak var emailIDTextField: YoshikoTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Forgot Password"
    }
    
    @IBAction func submitActionBtn(_ sender: UIButton) {
        FirebaseAPIHandler.sharedInstance.forgotPassword(emailId: emailIDTextField.text!) { (error) in
            if error == nil {
                DispatchQueue.main.async {
                    TWMessageBarManager.sharedInstance().showMessage(withTitle: "Reset", description: "Sent to your email", type: .info)
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)
                }
            }
        }
    }
    

}
