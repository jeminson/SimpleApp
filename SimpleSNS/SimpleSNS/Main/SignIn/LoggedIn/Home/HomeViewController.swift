//
//  HomeViewController.swift
//  SimpleSNS
//
//  Created by Je Min Son on 11/30/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: MRKBaseViewController {

    var postInfoArray : [UserPost] = []
    
    @IBOutlet weak var postTableView: UITableView!
    
    lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(HomeViewController.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.white
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchPost()
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "HOME"

        fetchPost()
        postTableView.addSubview(self.refreshControl)
    }

    func fetchPost() {
        
        SVProgressHUD.show(withStatus: "Loading Post...")
        FirebaseAPIHandler.sharedInstance.fetchAllPost { (result) in
            
            self.postInfoArray = result as! [UserPost]
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.postTableView.reloadData()
            }
        }
        refreshControl.endRefreshing()
    }
    
    
    // MARK: - IBAction
    @IBAction func unwindToHomeVC(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func addPostBarBtn(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "AddPostViewController", sender: nil)
    }
}


// MARK: - TableView Delegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let post = self.postInfoArray[indexPath.row]
            (cell as! HomeTableViewCell).userNameLabel.text = post.postDetail.name
            (cell as! HomeTableViewCell).userProfileImg.image = post.postDetail.postUserImage
            (cell as! HomeTableViewCell).descriptionLabel.text = post.postDetail.description
            (cell as! HomeTableViewCell).postImgView.image = post.postDetail.postImage
            (cell as! HomeTableViewCell).likeButton.tag = indexPath.row
            (cell as! HomeTableViewCell).likeButton.addTarget(self, action: #selector(self.likeClick), for: .touchUpInside)

        }
        
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            (cell as! HomeTableViewCell).userNameLabel.text = nil
            (cell as! HomeTableViewCell).userProfileImg.image = nil
            (cell as! HomeTableViewCell).descriptionLabel.text = nil
            (cell as! HomeTableViewCell).postImgView.image = nil
        }
    }
    
    @objc func likeClick(_ sender: UIButton) {
//        let post = self.postInfoArray[sender.tag]
//        let indexPath = IndexPath(item: sender.tag, section: 0)
//        var isBool = false
//
//        if post.postDetail.isLike == false {
//            isBool = true
//        } else {
//            isBool = false
//        }
//
//        FirebaseAPIHandler.sharedInstance.likePost(postKey: post.postId!, isLike: isBool) { (err) in
//            if err == nil {
//                DispatchQueue.main.async {
//                    self.postTableView.reloadRows(at: [indexPath], with: .none)
//                }
//            }
//        }


    }
    
}


// MARK: - TableView DataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        
        return cell
    }
    
    
}

