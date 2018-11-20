//
//  SignUpViewController.swift
//  Demo
//
//  Created by Je Min Son on 11/19/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    var placeHolderArray : [String] = ["First Name", "Last Name", "Email ID", "Address", "Phone Number", "City", "State", "Country", "Password", "Re-Enter Password"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SIGN UP"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }



}

extension SignUpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeHolderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpTableViewCell") as! SignUpTableViewCell
        
        cell.signUpTextField.placeholder = placeHolderArray[indexPath.row]
        
        return cell
    }
    
    
}

