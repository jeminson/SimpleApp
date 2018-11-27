//
//  HomeViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/22/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit

class HomeViewController: MRKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "HOME"
    }
    

    @IBAction func addPostBarButton(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "AddPostViewController", sender: nil)
        }
    }
    
    

}
