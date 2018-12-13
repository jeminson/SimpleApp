//
//  UserViewController.swift
//  SimpleSNS
//
//  Created by Je Min Son on 11/30/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserViewController: MRKBaseViewController {
    
    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var totalUserLabel: UILabel!
    @IBOutlet weak var allUserTableView: UITableView!
    
    var userInfoArray : [UserModel] = []
    var unSortedUserInfoArray : [UserModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "User"
        
        fetchAllUser()
        
        let tapper = UITapGestureRecognizer(target: self, action:#selector(hideKeyboard))
        tapper.cancelsTouchesInView = false
        view.addGestureRecognizer(tapper)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    func fetchAllUser() {
        SVProgressHUD.show(withStatus: "Loading user lists")
        FirebaseAPIHandler.sharedInstance.fetchAllUsers { (result) in

            self.userInfoArray = result as! [UserModel]
            self.unSortedUserInfoArray = result as! [UserModel]

            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.totalUserLabel.text = String("Total : \(self.userInfoArray.count)")
                self.allUserTableView.reloadData()
            }
        }
    }
    
    // MARK: - IBAction
    @IBAction func mapBarButton(_ sender: UIBarButtonItem) {
        SVProgressHUD.show()
        if let controller = storyboard?.instantiateViewController(withIdentifier: "GMapViewController") as? GMapViewController {
            
            controller.userInfoArray = userInfoArray
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}


// MARK: - Searchbar Delegate
extension UserViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        searchBar.text = searchText.uppercased()
        userInfoArray = unSortedUserInfoArray.filter({($0.firstName!.uppercased().contains(searchBar.text!))})
        
        DispatchQueue.main.async {
            self.allUserTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        userInfoArray = unSortedUserInfoArray
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        DispatchQueue.main.async {
            self.allUserTableView.reloadData()
        }
    }
}


// MARK: - Tableview Delegate
extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let user = self.userInfoArray[indexPath.row]
            (cell as! UserTableViewCell).firstNameLabel.text = user.firstName
            (cell as! UserTableViewCell).lastNameLabel.text = user.lastName
            (cell as! UserTableViewCell).profileImgView.image = user.image
            
            (cell as! UserTableViewCell).addFriendBtn.tag = indexPath.row
            (cell as! UserTableViewCell).addFriendBtn.addTarget(self, action: #selector(self.addFriend), for: .touchUpInside)
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            (cell as! UserTableViewCell).firstNameLabel.text = nil
            (cell as! UserTableViewCell).lastNameLabel.text = nil
            (cell as! UserTableViewCell).profileImgView.image = nil
        }
    }
    
    @objc func addFriend(_ sender: UIButton) {
        let user = userInfoArray[sender.tag]
        //        let cell = self.tableView(self.allUserTableView, cellForRowAt: IndexPath(row: sender.tag, section: 0)) as! UserTableViewCell
        
        let AlertController = UIAlertController(title: "Add Friend", message: "Do you want to add as your friend?", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "ADD", style: .default) { action in
            FirebaseAPIHandler.sharedInstance.addToFriendList(friendId: user.userId!) { (result) in
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (result) in
            print("cancel")
        }
        
        AlertController.addAction(addAction)
        AlertController.addAction(cancelAction)
        
        present(AlertController, animated: true, completion: nil)
    }
}

// MARK: - TableView DataSource
extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        
        return cell
    }
}
