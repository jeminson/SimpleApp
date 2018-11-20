//
//  ViewController.swift
//  Demo
//
//  Created by Je Min Son on 11/19/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import Firebase
import TWMessageBarManager

class SignInViewController: MRKBaseViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func signUpActionButton(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func forgotPasswordActionButton(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func signInActionButton(_ sender: UIButton) {
        signIn(email:self.usernameTextField.text!, passwd:self.passwordTextField.text!)
    }
    
    
    
}

extension SignInViewController {
    func signIn(email:String, passwd:String)  {
        
        Auth.auth().signIn(withEmail: email, password: passwd) { (result, error) in
            
            if error == nil{
                guard let user = result?.user else { return }
                
                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoggedInViewController") as? LoggedInViewController {
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                
            }else{
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)
                //  print(error?.localizedDescription)
            }
            
        }
    }
}
