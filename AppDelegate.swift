//
//  AppDelegate.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 25/10/2019.
//  Copyright © 2019 Solution Soul. All rights reserved.
//

import UIKit
import CallKit
import PushKit
import Firebase
import FirebaseAuth
import GoogleMaps
import IQKeyboardManagerSwift
import SVProgressHUD
import GooglePlaces
import Braintree


let apiKey = "AIzaSyC9FYDwGQHh5GXh_uEadKPnHO693WA6sY0"

var dailerCheck = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var callObserver: CXCallObserver!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //SVProgressHUD.setDefaultMaskType(.black)
        
        callObserver = CXCallObserver()
        callObserver.setDelegate(self, queue: nil)
        
        GMSServices.provideAPIKey(apiKey)
        GMSPlacesClient.provideAPIKey("AIzaSyCkaRemlvhw3sMPaUmC339iQ815zLGxNz4")
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
       // PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "AacreOcvE_eUIAl5ZGAtKP46toEz7Wi5mVcWqpVSqXsdwK9yGmkrYaES_B-IKhVNA2wRXEjC8r5zrqwL", PayPalEnvironmentSandbox: "sb-uos973960529@business.example.com"])
        BTAppSwitch.setReturnURLScheme("com.solutionsoul.DailerApplication.payments")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare("com.solutionsoul.DailerApplication.payments") == .orderedSame {
            return BTAppSwitch.handleOpen(url, options: options)
            
        }
        return false
    }
    
}

extension AppDelegate: CXCallObserverDelegate {
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.hasEnded == true {
            print("Disconnected")
            let disconnectedCallTimestamp =  Date().currentTimeMillis()
            print(disconnectedCallTimestamp)
            
        }
        if call.isOutgoing == true && call.hasConnected == false {
            print("Dialing")
            let dialingCallTimestampd =  Date().currentTimeMillis()
            print(dialingCallTimestampd)
            
            let dialingCallTimestamp = Int(dialingCallTimestampd/1000)
            
            print("Your are dailing to \(callerName), number : \(callerNumber)")
            
            var userID = ""
            if let userid = defaults.string(forKey: userData.id) {
                print(userid) // Another String Value
                userID = userid
            }
            
            if dailerCheck {
                dailerCheck = false
                let ref = Database.database().reference().child("callsLog").child(userID)
                let key = ref.childByAutoId().key
                let data = ["callEndTime":dialingCallTimestamp,"callStartTime":dialingCallTimestamp,"callType":"outgoing","id":key!,"name":callerName,"phoneNumber":callerNumber] as [String : Any]
                ref.child(key!).setValue(data)
            }
            
        }
        if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            print("Incoming")
            let incomingCallTimestamp =  Date().currentTimeMillis()
            print(incomingCallTimestamp)
            
//            if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IncommingCallViewController") as? IncommingCallViewController {
//                if let window = self.window, let rootViewController = window.rootViewController {
//                    var currentController = rootViewController
//                    while let presentedController = currentController.presentedViewController {
//                        currentController = presentedController
//                    }
//                    currentController.present(controller, animated: true, completion: nil)
//                }
//            }
            
        }
        if call.hasConnected == true && call.hasEnded == false {
            print("Connected")
            
        }
//        func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, forType type: PKPushType) {
//            // report new incoming call
//            print("report new incoming call")
//
//            print(payload.dictionaryPayload)
//
//        }
    }
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
