//
//  AppDelegate.swift
//  FinChat
//
//  Created by Артём Мурашко on 17.02.2021.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        logPrint(#function)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        logPrint(#function)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        logPrint(#function)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        logPrint(#function)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        logPrint(#function)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        logPrint(#function)
    }
    
    func logPrint(_ methodName : String) {
        if (logSwitch) {
            switch (methodName) {
            case "application(_:didFinishLaunchingWithOptions:)" :
                print("Application moved from Not Running to Inactive: " + methodName)
            case "applicationWillResignActive(_:)" :
                print("Application moved from Active to Inactive: " + methodName)
            case "applicationDidEnterBackground(_:)" :
                print("Application moved from Inactive to Background: " + methodName)
            case "applicationWillEnterForeground(_:)" :
                print("Application moved from Background to Inactive: " + methodName)
            case "applicationDidBecomeActive(_:)" :
                print("Application moved from Inactive to Active: " + methodName)
            case "applicationWillTerminate(_:)" :
                print("Application moved from Background to Not Running: " + methodName)
            default:
                print("Something strange in AppDelegate :D")
            }
        }
    }
}
