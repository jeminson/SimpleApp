//
//  EditUserViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/22/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit

class EditUserViewController: MRKBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "EDIT USER"
    }


}

extension EditUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditUserTableViewCell") as! EditUserTableViewCell
        
        return cell
    }
    
    
}
