//
//  ChangePasswordViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/27/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Change Password"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.hidesBackButton = false
    }


}
