//
//  SettingViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/20/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import TWMessageBarManager

class SettingViewController: MRKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Setting"
    }
    


    @IBAction func logoutActionButton(_ sender: UIButton) {
        let mainStoreBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = mainStoreBoard.instantiateViewController(withIdentifier: "SignInViewController")
        UIApplication.shared.keyWindow?.rootViewController = controller
        
        TWMessageBarManager.sharedInstance().showMessage(withTitle: "Sucess", description: "Successfully logged out", type: .success)
    }
    
}
