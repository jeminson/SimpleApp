//
//  LoggedInViewController.swift
//  Demo
//
//  Created by Je Min Son on 11/20/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import Firebase

class LoggedInViewController: UIViewController {

    var databaseRef : DatabaseReference!
    var test = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        databaseRef = Database.database().reference().child("USERS")

        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}


extension LoggedInViewController {
    func fetchData() {
        
//        let userID = Auth.auth().currentUser?.uid
        databaseRef.observeSingleEvent(of: .value) { (snapshot) in
            if let array = snapshot.value as? [String: Any]{
                
//                print(array)
//                for dict in array{
//                    print(dict)
//                }
//                print(array.count)
                self.test = array
                print(self.test)
                
            }
            
            
        }
        
    }
}

extension LoggedInViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoggedInTableViewCell") as! LoggedInTableViewCell
        
        
        cell.nameLabel?.text = ""
        
        return cell
    }
    
    
}
