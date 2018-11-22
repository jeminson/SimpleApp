//
//  HomeViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/20/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit

class HomeViewController: MRKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "HOME"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.hidesBackButton = true
    }

}
