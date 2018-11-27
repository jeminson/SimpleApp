//
//  AddPostViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/27/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Post"
    }
    
    @IBAction func postBarButton(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
