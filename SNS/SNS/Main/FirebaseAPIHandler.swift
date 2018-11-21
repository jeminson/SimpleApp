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
import TWMessageBarManager

//typealias completionHandler = (Any?, Error?) ->()

class FirebaseAPIHandler: NSObject {
    // MARK: - Singleton class
    static let sharedInstance = FirebaseAPIHandler()
    private override init() {}

    var databaseRef : DatabaseReference! = Database.database().reference().child("USERS")
}

extension FirebaseAPIHandler {
    func signUp(userInfo: UserInfo) {
        
        Auth.auth().createUser(withEmail: userInfo.emailId!, password: userInfo.password!) { (result, error) in
            if error == nil {

                guard let user = result?.user else {return}
                
                self.databaseRef.child(user.uid).setValue(["ID":user.uid, "EmailId":userInfo.emailId!, "FirstName": userInfo.firstName!, "LastName": userInfo.lastName!, "Address": userInfo.address!, "Phone Number": userInfo.phoneNumber!], withCompletionBlock: { (error, ref) in
                    
                    if error == nil {
                        print(ref)
                    }
                })

                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Sucess", description: "Successfully register the new user", type: .success)
            } else {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)
            }
        }
    } // End signUp func
    
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Reset", description: "Sent to your email", type: .info)
            } else {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)
            }
        }
    } // End resetPassword func
    
    func signIn(email: String, passwd: String) {
        
        Auth.auth().signIn(withEmail: email, password: passwd) { (result, error) in
            if error == nil {
                guard let user = result?.user else {return}

                print(user)
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success", description: "Successfully logged in", type: .success)
            } else {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)
            }
        }
        
    } // End signIn func
    

}
