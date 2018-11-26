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

typealias completionHandler = (Error?) ->()

class FirebaseAPIHandler: NSObject {
    // MARK: - Singleton class
    static let sharedInstance = FirebaseAPIHandler()
    private override init() {}

    var databaseRef : DatabaseReference! = Database.database().reference().child("USERS")
    var storageRef: StorageReference! = Storage.storage().reference()
}

extension FirebaseAPIHandler {
    func signUp(userInfo: UserInfo, img: UIImage, completion: @escaping completionHandler) {
        
        Auth.auth().createUser(withEmail: userInfo.emailId!, password: userInfo.password!) { (result, error) in
            if error == nil {

                guard let user = result?.user else {return}
                
                self.databaseRef.child(user.uid).setValue(["ID":user.uid, "EmailId":userInfo.emailId!, "FirstName": userInfo.firstName!, "LastName": userInfo.lastName!, "Address": userInfo.address!, "Phone Number": userInfo.phoneNumber!], withCompletionBlock: { (error, ref) in
                    
                    if error == nil {
//                        print(ref)
                        self.uploadImage(userID: user.uid, image: img)
                    }
                })

                completion(nil)
            } else {
                completion(error!)
            }
        }
    } // End signUp func
    
    func resetPassword(email: String, completion: @escaping completionHandler) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                completion(nil)
            } else {
                completion(error!)
            }
        }
    } // End resetPassword func
    
    func signIn(email: String, passwd: String, completion: @escaping completionHandler) {
    
        Auth.auth().signIn(withEmail: email, password: passwd) { (result, error) in
            if error == nil {
                guard let user = result?.user else {return}

                completion(nil)
            } else {
                completion(error!)
            }
        }
    } // End signIn func
    

    func uploadImage(userID: String, image: UIImage) {
        let data = image.pngData()
        let metaData = StorageMetadata()
        
        metaData.contentType = "image/png"
        
//        let imageName = "UserImages/\(userID).png"
        let imageName = "UserImages/\(String(describing: userID)).png"
        print(imageName)
        
//        storageRef = storageRef.child(imageName)
        storageRef.child(imageName).putData(data!, metadata: metaData) { (metaDataS, error) in
            
        }
        
        
    }
    
}
