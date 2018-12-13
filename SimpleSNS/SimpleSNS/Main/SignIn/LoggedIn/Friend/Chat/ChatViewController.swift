//
//  ChatViewController.swift
//  SimpleSNS
//
//  Created by Je Min Son on 11/30/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit

class ChatViewController: MRKBaseViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var chatTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chat"
        
        let tapper = UITapGestureRecognizer(target: self, action:#selector(hideKeyboard))
        tapper.cancelsTouchesInView = false
        view.addGestureRecognizer(tapper)
        
        self.navBar.setBackgroundImage(UIImage(), for: .default)
        self.navBar.shadowImage = UIImage()
        self.navBar.isTranslucent = true
        
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func doneBarBtn(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "unwindSegue", sender: self)
        }
    }
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
        
        cell.receiverFirstNameLabel.text = "Receiver Name"
        cell.receiverMesssageLabel.text = "Hello Sender"
        cell.receiverTimeLabel.text = "18:00"
        
        cell.senderFirstNameLabel.text = "Sender Name"
        cell.senderMessageLabel.text = "Hi Receiver"
        cell.senderTimeLabel.text = "18:30"
        
        return cell
    }
}
