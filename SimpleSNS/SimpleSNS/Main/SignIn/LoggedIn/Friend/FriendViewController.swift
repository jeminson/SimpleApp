//
//  FriendViewController.swift
//  SimpleSNS
//
//  Created by Je Min Son on 11/30/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import SVProgressHUD

class FriendViewController: MRKBaseViewController {

    @IBOutlet weak var friendSearchBar: UISearchBar!
    @IBOutlet weak var totalFriendLabel: UILabel!
    @IBOutlet weak var friendTableView: UITableView!
    
    var friendListArray: [UserModel] = []
    var unFilteredFriendListArray : [UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Friends"
        
        let tapper = UITapGestureRecognizer(target: self, action:#selector(hideKeyboard))
        tapper.cancelsTouchesInView = false
        view.addGestureRecognizer(tapper)
        
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFriends()
    }

    
    func fetchFriends() {
        
        SVProgressHUD.show(withStatus: "Loading friends list")
        FirebaseAPIHandler.sharedInstance.fetchFriendList { (result) in
            self.friendListArray = result ?? []
            self.unFilteredFriendListArray = result ?? []
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                
                self.totalFriendLabel.text = String("Total : \(self.friendListArray.count)")
                self.friendTableView.reloadData()
            }
        }
    }

}

// MARK: - TableView Delegate
extension FriendViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let user = self.friendListArray[indexPath.row]
            (cell as! FriendTableViewCell).firstNameLabel.text = user.firstName
            (cell as! FriendTableViewCell).lastNameLabel.text = user.lastName
            (cell as! FriendTableViewCell).friendProfileImgView.image = user.image
            
            (cell as! FriendTableViewCell).unfriendBtn.tag = indexPath.row
            (cell as! FriendTableViewCell).unfriendBtn.addTarget(self, action: #selector(self.unFriend), for: .touchUpInside)
            (cell as! FriendTableViewCell).chatBtn.tag = indexPath.row
            (cell as! FriendTableViewCell).chatBtn.addTarget(self, action: #selector(self.chatNow), for: .touchUpInside)
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            (cell as! FriendTableViewCell).firstNameLabel.text = nil
            (cell as! FriendTableViewCell).lastNameLabel.text = nil
            (cell as! FriendTableViewCell).friendProfileImgView.image = nil
        }
    }
    
    @objc func unFriend(_ sender: UIButton) {
        let friends = friendListArray[sender.tag]
        
        let AlertController = UIAlertController(title: "Remove Friend", message: "Do you want to remove from your friend?", preferredStyle: .alert)
        let removeAction = UIAlertAction(title: "REMOVE", style: .default) { action in
            FirebaseAPIHandler.sharedInstance.removeFromFriendList(friendId: friends.userId!) { (result) in
                
                DispatchQueue.main.async {
                    self.friendListArray.remove(at: sender.tag)
                    self.totalFriendLabel.text = String("Total : \(self.friendListArray.count)")
                    self.friendTableView.reloadData()
                }
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (result) in
            print("cancel")
        }
        
        AlertController.addAction(removeAction)
        AlertController.addAction(cancelAction)
        
        present(AlertController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToFriendVC(segue: UIStoryboardSegue) {
        
    }
    
    @objc func chatNow(_ sender: UIButton) {
        
        let AlertController = UIAlertController(title: "Start Chat", message: "Do you want to chat with your friend?", preferredStyle: .alert)
        let startChatAction = UIAlertAction(title: "Go chat", style: .default) { action in
            self.performSegue(withIdentifier: "ChatViewController", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (result) in
            print("cancel")
        }
        
        AlertController.addAction(startChatAction)
        AlertController.addAction(cancelAction)
        
        present(AlertController, animated: true, completion: nil)
    }
    
}

// MARK: - Searchbar Delegate
extension FriendViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.text = searchText.uppercased()
        friendListArray = unFilteredFriendListArray.filter({($0.firstName!.uppercased().contains(searchBar.text!))})
        
        DispatchQueue.main.async {
            self.friendTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        friendListArray = unFilteredFriendListArray
        searchBar.text = ""
        searchBar.resignFirstResponder()
        DispatchQueue.main.async {
            self.friendTableView.reloadData()
        }
    }
}


// MARK: - TableView DataSource
extension FriendViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell") as! FriendTableViewCell
        
        return cell
    }

}
