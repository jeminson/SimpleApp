//
//  EditUserViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/22/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit

class EditUserViewController: MRKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "EDIT USER"
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.hidesBackButton = false
    }

}
