//
//  UserViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/22/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit

class UserViewController: MRKBaseViewController {

    @IBOutlet weak var userTableView: UITableView!
    var userInfoArray : [UserInfo] = []
    var count : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "USER"
        
        FirebaseAPIHandler.sharedInstance.fetchTheData { (result, error) in
            if error == nil {
                self.userInfoArray = result as! [UserInfo]
                
                DispatchQueue.main.async {
                    self.userTableView.reloadData()
                }
            }
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.hidesBackButton = true
    }

}


extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        
        return cell
    }
}
