//
//  FirebaseAPIHandler.swift
//  SimpleSNS
//
//  Created by Je Min Son on 11/29/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import Foundation
import UIKit            // UIImage
import Firebase

class FirebaseAPIHandler {
    // MARK: - Singleton class
    static let sharedInstance = FirebaseAPIHandler()
    private init() {}
    
    var userReference: DatabaseReference!
    var userStorageReference: StorageReference!
    var postReference: DatabaseReference!
    
    func initDataBase() {
        userReference = Database.database().reference().child("USER")
        userStorageReference = Storage.storage().reference()
        postReference = Database.database().reference().child("POST")
    } // End initDataBase function
    
    func getCurrentUid() -> String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
} // End FirebaseAPIHandler

extension FirebaseAPIHandler {
    // MARK: - Sign up Function for new users
    func signUpNewUser(userInfo: UserModel, userImg: UIImage, completion: @escaping (Any?, Error?) -> Void) {
        initDataBase()
        Auth.auth().createUser(withEmail: userInfo.emailId!, password: userInfo.password!) { (result, error) in
            
            if error == nil {
                guard let user = result?.user else { return }
                
                let coordinate = ["Latitude": userInfo.latitude, "Longitude": userInfo.longitude]
                let userInfoDict = ["First Name": userInfo.firstName, "Last Name": userInfo.lastName, "Email Id": userInfo.emailId, "Address": userInfo.address, "Phone Number": userInfo.phoneNumber, "Coordinate": coordinate] as [String : Any?]
                
                self.userReference.child(user.uid).setValue(userInfoDict, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        self.uploadImage(userId: user.uid, img: userImg) { (result, error) in
                            if error == nil {
                                completion(result, nil)
                            } else {
                                completion(nil, error)
                            }
                        }
                    } else {
                        completion(nil, error)
                    }
                })
            } else {
                completion(nil, error)
            }
        }
    } // End signUpNewUser
    
    func uploadImage(userId: String, img: UIImage, completion: @escaping (Any?, Error?) -> Void) {
        let data = img.jpeg(.lowest)
        let metaData = StorageMetadata()
        
        metaData.contentType = "image/png"
        
        let imageName = "UserImages/\(String(describing: userId)).png"
        
        userStorageReference.child(imageName).putData(data!, metadata: metaData) { (meta, error) in
            if error == nil {
                completion(imageName, nil)
            } else {
                completion(nil, error)
            }
        }
    } // End uploadImage
    
    // MARK: - Forgot Password & Reset Password
    func forgotPassword(emailId: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: emailId) { (error) in
            if error == nil {
                completion(nil)
            } else {
                completion(error)
            }
        }
    }
    
    func resetPassword() {
        let currentUserEmail = Auth.auth().currentUser?.email
        Auth.auth().sendPasswordReset(withEmail: currentUserEmail!) { (error) in
            if error == nil {
                
            }
        }
    }
    
    // MARK: - Sign In
    func signIn(emailId: String, passwd: String, completion: @escaping (User, Error?) -> ()) {
        initDataBase()
        Auth.auth().signIn(withEmail: emailId, password: passwd) { (result, error) in
            if error == nil {
                guard let user = result?.user else {return}
                completion(user, nil)
            } else {
//                completion(nil, error)
            }
        }
    }
    
    // MARK: - Logout
    func logout() {
        try!  Auth.auth().signOut()
    }
    
    // MARK: - Fetching Part
//    func fetchCurrentUser(completion: @escaping (Any?, Error?) -> ()) {
//        initDataBase()
//
//        let fetchUserGroup = DispatchGroup()
//        let fetchUserComponentsGroup = DispatchGroup()
//        fetchUserGroup.enter()
//        
//        userReference.child(getCurrentUid()).observeSingleEvent(of: .value) { (snapshot, error) in
//            if let userInfoDict = snapshot.value as? [String:Any] {
//                let coordinate = userInfoDict["Coordinate"] as? [String:String]
//                var userModel = UserModel.init(userId: self.getCurrentUid(),
//                                               firstName: userInfoDict["First Name"] as? String,
//                                               lastName: userInfoDict["Last Name"] as? String,
//                                               emailId: userInfoDict["Email Id"] as? String,
//                                               address: userInfoDict["Address"] as? String,
//                                               phoneNumber: userInfoDict["Phone Number"] as? String,
//                                               password: nil,
//                                               image: nil,
//                                               latitude: coordinate?["Latitude"],
//                                               longitude: coordinate?["Longitude"])
//
//                fetchUserComponentsGroup.enter()
//                self.getCurrentUserImage(userID: self.getCurrentUid(), completion: { (img, error) in
//                    if error == nil && !(img == nil) {
//                        userModel.image = img as? UIImage
//                    }
//                    fetchUserComponentsGroup.leave()
//                })
//
//                fetchUserComponentsGroup.notify(queue: .main) {
//                    fetchUserGroup.leave()
//                }
//
//                fetchUserGroup.notify(queue: .main) {
//                    completion(userModel, nil)
//                }
//            } else {
//                completion(nil, error as? Error)
//            }
//
//        }
//    } // End fetchCurrentUser func
//
//    func getCurrentUserImage(userID: String, completion: @escaping (Any?, Error?) -> ()) {
//        let imageName = "UserImages/\(String(describing: userID)).png"
//        
//        userStorageReference.child(imageName).getData(maxSize: 10*1024*1024) { (data, error) in
//            if error == nil {
//                let image = UIImage(data: data!)
//                
//                completion(image, nil)
//            } else {
//                completion(nil, error)
//            }
//        }
//    }
    
    func fetchCurrentUser(completion: @escaping (UserModel?) -> ()) {
        initDataBase()
        
        userReference.child(getCurrentUid()).observeSingleEvent(of: .value) { (snapshot) in
            if let userInfoDict = snapshot.value as? [String:Any] {
                let coordinate = userInfoDict["Coordinate"] as? [String:String]
                let userModel = UserModel.init(userId: self.getCurrentUid(),
                                               firstName: userInfoDict["First Name"] as? String,
                                               lastName: userInfoDict["Last Name"] as? String,
                                               emailId: userInfoDict["Email Id"] as? String,
                                               address: userInfoDict["Address"] as? String,
                                               phoneNumber: userInfoDict["Phone Number"] as? String,
                                               password: nil,
                                               image: nil,
                                               latitude: coordinate?["Latitude"],
                                               longitude: coordinate?["Longitude"])
                completion(userModel)
            } else {
                completion(nil)
            }
            
        }
    } // End fetchCurrentUser func

    
    func fetchCurrentUserImage(completion: @escaping (UIImage?, Error?) -> ()) {
        initDataBase()
        
        let imageName = "UserImages/\(String(describing: getCurrentUid())).png"
        
        userStorageReference.child(imageName).getData(maxSize: 10*1024*1024) { (data, error) in
            if error == nil {
                let image = UIImage(data: data!)
                completion(image, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func fetchAllUsers(completion: @escaping (Any?) -> ()) {
        initDataBase()
        
        let fetchUserGroup = DispatchGroup()
        let fetchUserComponentsGroup = DispatchGroup()
        fetchUserGroup.enter()
        
        userReference.observeSingleEvent(of: .value) { (snapshot, error) in
            if error == nil {
                var userInfoArray : [UserModel] = []
                
                if let users = snapshot.value as? [String:[String:Any]] {
                    for user in users {
                        let coordinate = user.value["Coordinate"] as? [String:String]
                        var userModel = UserModel.init(userId: user.key,
                                                       firstName: user.value["First Name"] as? String,
                                                       lastName: user.value["Last Name"] as? String,
                                                       emailId: user.value["Email Id"] as? String,
                                                       address: user.value["Address"] as? String,
                                                       phoneNumber: user.value["Phone Number"] as? String,
                                                       password: nil,
                                                       image: nil,
                                                       latitude: coordinate?["Latitude"],
                                                       longitude: coordinate?["Longitude"])
                        fetchUserComponentsGroup.enter()
                        self.fetchAllUserImage(userID: user.key, completion: { (img, error) in
                            if error == nil && !(img == nil) {
                                userModel.image = img as? UIImage
                            }
                            
                            if userModel.userId != self.getCurrentUid() {
                                userInfoArray.append(userModel)
                            }
                            fetchUserComponentsGroup.leave()
                        })
                    }
                    fetchUserComponentsGroup.notify(queue: .main) {
                        fetchUserGroup.leave()
                    }
                    
                    fetchUserGroup.notify(queue: .main) {
                        // now the currentUser should be properly configured
                        completion(userInfoArray)
                    }
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func fetchAllUserImage(userID: String, completion: @escaping (Any?, Error?) -> ()) {
        let imageName = "UserImages/\(String(describing: userID)).png"
        
        userStorageReference.child(imageName).getData(maxSize: 10*1024*1024) { (data, error) in
            if error == nil {
                let image = UIImage(data: data!)
                
                completion(image, nil)
            } else {
                completion(nil, error)
            }
            
        }
    }
    
    func fetchFriendList(completion: @escaping ([UserModel]?) -> ()) {
        initDataBase()

        var friendArray : [UserModel] = []
        let friendListdispatchGroup = DispatchGroup()
        userReference.child(getCurrentUid()).child("FRIENDS").observeSingleEvent(of: .value) { (snapshot) in
            if let friends = snapshot.value as? [String:String] {
                for friend in friends {
                    friendListdispatchGroup.enter()
                    
                    self.userReference.child(friend.key).observeSingleEvent(of: .value) { (friendSnapShot) in
                        guard let singleFriend = friendSnapShot.value as? Dictionary<String, Any> else {return}
                        
                        let coordinate = singleFriend["Coordinate"] as? [String: String]
                        var userModel = UserModel.init(userId: friend.key,
                                                       firstName: singleFriend["First Name"] as? String,
                                                       lastName: singleFriend["Last Name"] as? String,
                                                       emailId: singleFriend["Email Id"] as? String,
                                                       address: singleFriend["Address"] as? String,
                                                       phoneNumber: singleFriend["Phone Number"] as? String,
                                                       password: nil,
                                                       image: nil,
                                                       latitude: coordinate?["Latitude"],
                                                       longitude: coordinate?["Longitude"])
                        self.fetchAllUserImage(userID: userModel.userId!, completion: { (img, error) in
                            if error == nil && !(img == nil) {
                                userModel.image = img as? UIImage
                                friendArray.append(userModel)
                                friendListdispatchGroup.leave()
                            }
                        })
                    }
                    friendListdispatchGroup.notify(queue: .main) {
                        completion(friendArray)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchAllPost(completion: @escaping (Any?) -> ()) {
        initDataBase()
        
        let dispatchGroup = DispatchGroup()
        let postDispatchGroup = DispatchGroup()

        postReference.observeSingleEvent(of: .value) { (snapshot) in
            var postInfoArray : [UserPost] = []
            
            if let posts = snapshot.value as? [String:[String:Any]] {
                for post in posts {
                    
                    postDispatchGroup.enter()
                    var postInfo = PostDetail.init(description: post.value["Description"] as? String,
                                                   imageRef: post.key,
                                                   like: nil,
                                                   timestamp: post.value["timeStamp"] as? Double,
                                                   userId: post.value["User Id"] as? String,
                                                   postImage: nil,
                                                   postUserImage: nil,
                                                   name: nil,
                                                   isLike: post.value["isLike"] as? Bool)
                    
                    dispatchGroup.enter()
                    self.fetchPostUserName(userId: postInfo.userId!) { (name) in
                        postInfo.name = name as? String
                        dispatchGroup.leave()
                    }
                    dispatchGroup.enter()
                    self.fetchAllUserImage(userID: postInfo.userId!) { (img, err) in
                        if err == nil {
                            postInfo.postUserImage = img as? UIImage
                        }
                        dispatchGroup.leave()
                    }
                    dispatchGroup.enter()
                    self.fetchPostImage(postKey: postInfo.imageRef!) { (img, err) in
                        if err == nil {
                            postInfo.postImage = img as? UIImage
                        }
                        dispatchGroup.leave()
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        let currentPostInfo = UserPost.init(postId: post.key, postDetail: postInfo)
                        postInfoArray.append(currentPostInfo)
                        postDispatchGroup.leave()
                    }
                }
                postDispatchGroup.notify(queue: .main) {
                    postInfoArray.sort() {$0.postDetail.timestamp ?? 0.0 > $1.postDetail.timestamp ?? 0.0}
                    completion(postInfoArray)
                }
            }
        }
    }
    
    func fetchPostUserName(userId: String, completion: @escaping (Any?) -> ()) {
        initDataBase()
        userReference.child(userId).child("First Name").observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.value as? String)
        }
    }
    func fetchPostImage(postKey: String, completion: @escaping (Any?, Error?) -> ()) {
        let imageName = "Posts/\(String(describing: postKey)).png"
        
        userStorageReference.child(imageName).getData(maxSize: 10*1024*1024) { (data, error) in
            if error == nil  {
                let image = UIImage(data: data!)
                completion(image, nil)
            } else {
                completion(nil, error)
            }
        }
    }


    
    // MARK: - Update information
    func updateUserInformation(updatedUserInfo: UserModel, updateProfileImg: UIImage, completion: @escaping (Any?, Error?)-> ()) {
        initDataBase()
        
//        let updateCoordinate = ["Latitude": updatedUserInfo.latitude, "Longitude": updatedUserInfo.longitude]
        let updateUserInfo = ["First Name": updatedUserInfo.firstName, "Last Name": updatedUserInfo.lastName, "Email Id": updatedUserInfo.emailId, "Address": updatedUserInfo.address, "Phone Number": updatedUserInfo.phoneNumber] as [String : Any?]
        
        self.userReference.child(getCurrentUid()).updateChildValues(updateUserInfo as [String : Any]) { (error, reference) in
            if error == nil {
                self.uploadImage(userId: self.getCurrentUid(), img: updateProfileImg) { (result, error) in
                    if error == nil {
                        completion(result, nil)
                    } else {
                        completion(nil, error)
                    }
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    // MARK: - Add & Remove Friends
    func addToFriendList(friendId: String, completion: @escaping (Any?) -> ()) {
        userReference.child(getCurrentUid()).child("FRIENDS").updateChildValues([friendId: "Friend Id"]) { (error, ref) in
            if error == nil {
                completion(ref) 
            } else {
                completion(error)
            }
        }
    }
    func removeFromFriendList(friendId: String, completion: @escaping (Any?) -> ()) {
        userReference.child(getCurrentUid()).child("FRIENDS").child(friendId).removeValue() { (error, ref) in
            if error == nil {
                completion(ref)
            } else {
                completion(error)
            }
        }
    }

    
    // MARK: - Add New Posts
    func addNewPost(postString: String, postImg: UIImage, completion: @escaping (Error?) -> ()) {
        initDataBase()
        
        let postKey = postReference.childByAutoId().key
        
        let postDispatchGroup = DispatchGroup()
        
        postReference.child(postKey!).setValue(["Description": postString,
                                                "timeStamp" : NSDate().timeIntervalSince1970,
                                                "User Id": getCurrentUid(),
                                                "isLike": false]) { (error, ref) in
            if error == nil {
                postDispatchGroup.enter()
                
                self.addPostStorage(img: postImg, postKey: postKey!, completion: { (err) in
                    if err == nil {
                        postDispatchGroup.leave()
                    } else {
                        completion(err)
                    }
                })
                postDispatchGroup.enter()
                self.addPostRefCurrentUser(postKey: postKey ?? "", completion: { (err) in
                    if err == nil {
                        postDispatchGroup.leave()
                    } else {
                        completion(err)
                    }
                })
                postDispatchGroup.notify(queue: .main) {
                    completion(nil)
                }
            } else {
                completion(error)
            }
        }
    }
    func addPostRefCurrentUser(postKey:String, completion: @escaping (Error?)->()){
        userReference.child(getCurrentUid()).child("POST").updateChildValues([postKey: "postKey"]) { (err, dbref) in
            completion(err)
        }
    }
    func addPostStorage(img: UIImage, postKey: String, completion: @escaping (Error?)->()){
        let data = img.jpeg(UIImage.JPEGQuality.lowest)
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        let imagename = "Posts/\(postKey).png"
        userStorageReference.child(imagename).putData(data!, metadata: metaData) { (storMetaData, err) in
            if err == nil{
                completion(nil)
            }else{
                completion(err)
            }
        }
    }
    
    // MARK: - Like & Unlike Posts
    func likePost(postKey: String, isLike: Bool, completion: @escaping (Any?) -> ()) {
        initDataBase()
        
//        print(isLike)
//
//        if isLike == true {
//            self.postReference.child(postKey).updateChildValues(["isLike": true] as [String:Bool]) { (error, reference) in
//                if error == nil {
//                    print("false -> true")
//                    completion(reference)
//                } else {
//                    completion(error)
//                }
//            }
//        } else {
//            self.postReference.child(postKey).updateChildValues(["isLike": false] as [String:Bool]) { (error, reference) in
//                if error == nil {
//                    print("true -> false")
//                    completion(reference)
//                } else {
//                    completion(error)
//                }
//            }
//        }
    }


}
