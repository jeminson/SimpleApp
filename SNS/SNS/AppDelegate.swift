//
//  AppDelegate.swift
//  SNS
//
//  Created by Je Min Son on 11/20/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

let googleKey = "AIzaSyDTw9hGyIyE2r64PQuAkfYY0Dm8XoZjndw"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        // Temp to let user be signed in
                if let curUser = Auth.auth().currentUser {
                    let mainStoryboard : UIStoryboard = UIStoryboard(name: "LoggedIn", bundle: nil)
                    let controller = mainStoryboard.instantiateViewController(withIdentifier: "LoggedInTabBarController")
                    self.window?.rootViewController = controller
                }
        
        // Google map
        GMSServices.provideAPIKey(googleKey)
        
        return true
    }


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

