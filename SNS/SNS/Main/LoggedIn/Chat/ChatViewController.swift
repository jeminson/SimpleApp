//
//  ChatViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/22/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit

class ChatViewController: MRKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chat"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.hidesBackButton = true
    }

}
