//
//  AppDelegate.swift
//  SimpleSNS
//
//  Created by Je Min Son on 11/29/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//


import UIKit
import Firebase
import GoogleMaps
import UserNotifications
import FirebaseMessaging

let PushWkey = "5c083c89a3fc27915a8b46b5"
let googleKey = "AIzaSyCqbQx_4bmrFdq19WvzpCc03bFykgGJ2y8"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    
    // APNs STEPS
    // 1. Register for APNs
    // 2. Successful app delegate method
    // 3. Failure app delegate method
    // 4. RECEIVE THE APNs THAT YOU'RE GETTING FROM THE APNs SERVER
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        // Temp to let user be signed in
        if let curUser = Auth.auth().currentUser {
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "LoggedIn", bundle: nil)
            let controller = mainStoryboard.instantiateViewController(withIdentifier: "LoggedInTabBarController")
            self.window?.rootViewController = controller
        }
        
        // Google map
        GMSServices.provideAPIKey(googleKey)
        
        // STEP 1:
        
        let setting = UNUserNotificationCenter.current()
        setting.requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
            if granted{
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
                
            }
        }
      
        return true
    }

    // Firebase Messaging
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        //Messaging.messaging().apnsToken = fcmToken
        
        print("token : \(fcmToken)")
        //cZEmvmdZNsw:APA91bH2S52LaVHOzlfM_WUUlwn2_N6IlIkf6BcabDdkM5lQi8URGEtGlFNmIv2qFEbVJOGYxiMpru_eooeW_bfqOmUqTG0oAcdTii9aWdDqP9k-O7Vfo2IOf-h8qdveM3ZmEh7yO0X7
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print(response)
    }
    // STEP 2: SUCCESS
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        let varAvgvalue = String(format: "%@", deviceToken as CVarArg)
        
        let  token = varAvgvalue.trimmingCharacters(in: CharacterSet(charactersIn: "<>")).replacingOccurrences(of: " ", with: "")
//        PushWizard.start(withToken: deviceToken, andAppKey: PushWkey, andValues: nil)
        Messaging.messaging().apnsToken = deviceToken

        //601d6125f2a5c0feb743eed4d1088d730edd5029d82a8fa52f58717a00bf951b
        print(token)    // String Output
    }
    
    // STEP 3: FAILURE
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        // TWMessageBarManager or Alert
    }
    
    // STEP 4: RECEIVE THE APNs THAT YOU'RE GETTING FROM THE APNs SERVER
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])
    {
        // USE THIS userInfo dict
        print(userInfo)
        PushWizard.handleNotification(userInfo, processOnlyStatisticalData: true)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
          PushWizard.handleNotification(userInfo, processOnlyStatisticalData: true)
        print(userInfo)
    }
    
    


}

