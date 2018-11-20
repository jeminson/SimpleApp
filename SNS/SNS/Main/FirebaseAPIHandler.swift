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
    // Singleton class
    static let sharedInstance = FirebaseAPIHandler()
    private override init() {}
    
    
    var databaseRef : DatabaseReference! = Database.database().reference().child("USERS")
    
}

extension FirebaseAPIHandler {
    
    func signUp(email:String, passwd:String, firstName:String)  {
        
        Auth.auth().createUser(withEmail: email, password: passwd) { (result, error) in
            
            if error == nil{
                guard let user = result?.user else { return }
                
                self.databaseRef.child(user.uid).setValue(["ID":user.uid, "FirstName": firstName, "EmailId":email], withCompletionBlock: { (error, ref) in
                    
                    if error == nil{
                        print(ref)
                    }
                    
                })
                
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Sucess", description: "Successfully register the new user", type: .success)
            }else{
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Error", description: error?.localizedDescription, type: .error)
            }
            
        }
    }

}
