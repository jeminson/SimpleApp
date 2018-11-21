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

typealias completionHandler = (Any?, Error?) ->()

class FirebaseAPIHandler: NSObject {
    // MARK: - Singleton class
    static let sharedInstance = FirebaseAPIHandler()
    private override init() {}
    
    
    var databaseRef : DatabaseReference! = Database.database().reference().child("USERS")
    
}

extension FirebaseAPIHandler {
    func signUp(email:String, passwd:String, firstName:String, lastName: String, address: String, phoneNumber: String)  {
        
        Auth.auth().createUser(withEmail: email, password: passwd) { (result, error) in
            
            if error == nil{
                guard let user = result?.user else { return }
                
                self.databaseRef.child(user.uid).setValue(["ID":user.uid, "EmailId":email, "FirstName": firstName, "LastName": lastName, "Address": address, "Phone Number": phoneNumber], withCompletionBlock: { (error, ref) in
                    
                    if error == nil{
                        print(ref)
                    }
                })
                
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Sucess", description: "Successfully register the new user", type: .success)
            }else{
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
    

}
