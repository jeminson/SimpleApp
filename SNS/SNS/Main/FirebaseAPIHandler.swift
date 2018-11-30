//
//  FirebaseAPIHandler.swift
//  SNS
//
//  Created by Je Min Son on 11/20/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

typealias completionHandler = (Any?, Error?) ->()

class FirebaseAPIHandler: NSObject {
    // MARK: - Singleton class
    static let sharedInstance = FirebaseAPIHandler()
    private override init() {}

    var databaseRef : DatabaseReference! = Database.database().reference().child("USERS")
    var storageRef: StorageReference! = Storage.storage().reference()
    var postRef: DatabaseReference! = Database.database().reference().child("POST")
}

extension FirebaseAPIHandler {
    func signUp(userInfo: UserInfo, img: UIImage, completion: @escaping completionHandler) {
        
        Auth.auth().createUser(withEmail: userInfo.emailId!, password: userInfo.password!) { (result, error) in
            if error == nil {

                guard let user = result?.user else {return}
                
                self.databaseRef.child(user.uid).setValue(["EmailId":userInfo.emailId!, "FirstName": userInfo.firstName!, "LastName": userInfo.lastName!, "Address": userInfo.address!, "Phone Number": userInfo.phoneNumber!], withCompletionBlock: { (error, ref) in
                    
                    if error == nil {
                        self.uploadImage(userID: user.uid, image: img)
                    }
                })

                completion(result, nil)
            } else {
                completion(nil, error)
            }
        }
    } // End signUp func
    
    func resetPassword(email: String, completion: @escaping completionHandler) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                completion(nil, nil)
            } else {
                completion(nil, error)
            }
        }
    } // End resetPassword func
    
    func signIn(email: String, passwd: String, completion: @escaping completionHandler) {
    
        Auth.auth().signIn(withEmail: email, password: passwd) { (result, error) in
            if error == nil {
                guard let user = result?.user else {return}

                completion(user, nil)
            } else {
                completion(nil, error)
            }
        }
    } // End signIn func
    

    func uploadImage(userID: String, image: UIImage) {
        let data = image.jpeg(.lowest)
        let metaData = StorageMetadata()
        
        metaData.contentType = "image/png"
        
        let imageName = "UserImages/\(String(describing: userID)).png"
        
        storageRef.child(imageName).putData(data!, metadata: metaData) { (metaDataS, error) in
            
        }
    } // End uploadImage
    
    func getImage(userID: String, completion: @escaping completionHandler) {
        let imageName = "UserImages/\(String(describing: userID)).png"
        
        storageRef.child(imageName).getData(maxSize: 10*1024*1024) { (data, error) in
            if error == nil {
                let image = UIImage(data: data!)
                
                completion(image, nil)
            } else {
                completion(nil, error)
            }
            
        }
    }

    
    func fetchTheData(completion: @escaping completionHandler) {

        let fetchUserGroup = DispatchGroup()
        let fetchUserComponentsGroup = DispatchGroup()
        fetchUserGroup.enter()

        let id = Auth.auth().currentUser?.uid
        
        databaseRef.observeSingleEvent(of: .value) { (snapshot, error) in
            if error == nil {
                var userArray : [UserInfo] = []

                if let users = snapshot.value as? [String: [String: Any]] {
                        
                    for user in users {
                        let coordinate = user.value["Coordinate"] as? [String:String]
                        var userModel = UserInfo.init(id: user.key,
                                                      firstName: user.value["FirstName"] as? String,
                                                      lastName: user.value["LastName"] as? String,
                                                      emailId: user.value["EmailId"] as? String,
                                                      address: user.value["Address"] as? String,
                                                      phoneNumber: user.value["Phone Number"] as? String,
                                                      password: nil,
                                                      img: nil,
                                                      latitude: coordinate?["Latitude"],
                                                      longitude: coordinate?["Longitude"])
                        
                        fetchUserComponentsGroup.enter()
                        self.getImage(userID: user.key, completion: { (img, error) in
                            if error == nil && !(img == nil) {
                                userModel.img = img as? UIImage
                            }
                            
                            if userModel.id != id {
                                userArray.append(userModel)
                            }
                            fetchUserComponentsGroup.leave()
                        })
                        

                    }
                    fetchUserComponentsGroup.notify(queue: .main) {
                        fetchUserGroup.leave()
                    }
                    
                    fetchUserGroup.notify(queue: .main) {
                        // now the currentUser should be properly configured
                        completion(userArray, nil)
                    }
                } else {
                    completion(nil, error as? Error)
                }
                
            }

        }
    }
    
    func logoutFromFirebase() {
        
        try!  Auth.auth().signOut()
    }
    

    func getCurrentUid() -> String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    func addPost(postString: String, postImg: UIImage, completion: @escaping completionHandler) {
        let postKey = postRef.childByAutoId().key
        
        let dg = DispatchGroup()

        postRef.child(postKey!).setValue(["description": postString,
                                          "userId": getCurrentUid()], withCompletionBlock: { (error, ref) in
                                            if error == nil {
                                                dg.enter()
                                                self.addPostStorage(img: postImg, postKey: postKey!, completion: { (err) in
                                                    if err == nil{
                                                        dg.leave()
                                                    }else{
                                                        completion(nil, err)
                                                    }
                                                })
                                                dg.enter()
                                                self.addPostRefCurrentUser(postKey: postKey ?? "", completion: { (err) in
                                                    if err == nil{
                                                        dg.leave()
                                                    }else{
                                                        completion(nil, err)
                                                    }
                                                })
                                                dg.notify(queue: .main){
                                                    print("Print hopefully once!")
                                                    completion(nil, nil)
                                                }
                                            } else {
                                                print(error)
                                            }
                                            
        })
    }
    
    func addPostRefCurrentUser(postKey:String, completion: @escaping (Error?)->()){
        databaseRef.child(getCurrentUid()).child("POST").updateChildValues([postKey: "postKey"]) { (err, dbref) in
            completion(err)
        }
    }
    
    func addPostStorage(img: UIImage, postKey: String, completion: @escaping (Error?)->()){
        let data = img.jpeg(UIImage.JPEGQuality.lowest)
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        let imagename = "Posts/\(postKey)"
        storageRef.child(imagename).putData(data!, metadata: metaData) { (storMetaData, err) in
            if err == nil{
                completion(nil)
            }else{
                completion(err)
            }
        }
    }

    
    
    
    
}
