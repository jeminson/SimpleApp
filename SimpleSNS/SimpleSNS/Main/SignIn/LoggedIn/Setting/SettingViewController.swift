//
//  SettingViewController.swift
//  SimpleSNS
//
//  Created by Je Min Son on 11/30/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import TWMessageBarManager
import SVProgressHUD

class SettingViewController: MRKBaseViewController {

    let buttonArray = ["Edit Profile", "Reset Password"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Setting"
    }
    
    @IBAction func actionBtn(_ sender: UIButton) {
            SVProgressHUD.show(withStatus: "Logging Out")
            FirebaseAPIHandler.sharedInstance.logout()
            let mainStoreBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = mainStoreBoard.instantiateViewController(withIdentifier: "SignInViewController")
            UIApplication.shared.keyWindow?.rootViewController = controller
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Sucess", description: "Successfully logged out", type: .success)
            }
    }
    
}



extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttonArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell") as! SettingTableViewCell
        
        cell.btnLabel.text = buttonArray[indexPath.row]
        cell.actionBtn.tag = indexPath.row
        
        switch indexPath.row {
        case 0:
            cell.actionBtn.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        case 1:
            cell.actionBtn.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        default:
            break
        }
        
        return cell
    }
    
    @objc func editProfile(_ sender: UIButton) {
        performSegue(withIdentifier: "EditProfileViewController", sender: nil)
    }
    
    @objc func resetPassword(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Reset Password", message: "Click OK to send reset password request to your email", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            FirebaseAPIHandler.sharedInstance.resetPassword() 
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
