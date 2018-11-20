//
//  SignUpViewController.swift
//  Demo
//
//  Created by Je Min Son on 11/19/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import Firebase
import TWMessageBarManager

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    var datebaseReference: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SIGN UP"
        
        datebaseReference = Database.database().reference().child("USERS")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func submitActionButton(_ sender: UIButton) {
        signUp(email: emailTextField.text!, passwd: passwordTextField.text!)
    }
}

extension SignUpViewController {
    func signUp(email: String, passwd: String) {
        Auth.auth().createUser(withEmail: email, password: passwd) { (result, error) in
            
            if error == nil {
                
                guard let user = result?.user else {return}
                
                self.datebaseReference.child(user.uid).setValue(["ID":user.uid, "FirstName": self.firstNameTextField.text!, "LastName": self.lastNameTextField.text!,"EmailId":email, "Address":self.addressTextField.text!, "PhoneNumber":self.phoneNumberTextField.text!], withCompletionBlock: { (error, reference) in
                    
                    if error == nil{
                        print(reference)
                    }
                    
                })
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Sucess", description: "Successfully register the new user", type: .success)
            } else{
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)
            }
            
        }
    }
}


