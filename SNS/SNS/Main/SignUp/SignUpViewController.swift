//
//  SignUpViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/20/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit

class SignUpViewController: MRKBaseViewController {

    var placeHolderArray : [String] = ["First Name", "Last Name", "Email ID", "Address", "Phone Number", "Password"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign Up"
    }
    
}


extension SignUpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeHolderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpTableViewCell") as! SignUpTableViewCell
        
        cell.signUpTextField.placeholder = placeHolderArray[indexPath.row]
        
        if placeHolderArray[indexPath.row] == "Password" {
            cell.signUpTextField.isSecureTextEntry = true
        }
        
        return cell
    }
    
    
}
