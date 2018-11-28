//
//  UserViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/22/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserViewController: MRKBaseViewController {

    @IBOutlet weak var userTableView: UITableView!
    var userInfoArray : [UserInfo] = []
    var count : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "USER"
        
        SVProgressHUD.show()
        FirebaseAPIHandler.sharedInstance.fetchTheData { (result, error) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            
            if error == nil {
                self.userInfoArray = result as! [UserInfo]
                
                DispatchQueue.main.async {
                    self.userTableView.reloadData()
                }
            }
        }
        
    }
    @IBAction func addFriendButton(_ sender: UIButton) {
        
        let AlertController = UIAlertController(title: "Add Friend", message: "Do you want to add as your friend?", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "ADD", style: .default) { action in
            print("ADD")
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel)
        
        AlertController.addAction(addAction)
        AlertController.addAction(cancelAction)
        
        present(AlertController, animated: true, completion: nil)
    }

}


extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        
        let user = userInfoArray[indexPath.row]
        cell.firstNameLabel.text = user.firstName
        cell.lastNameLabel.text = user.lastName
        cell.userProfileImgView.image = user.img
        
        return cell
    }
}
