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
    lazy var snowEffect = TinkoffLogoSnowEffect(window: window!)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        // Make snow-logo effect on every window
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(screenTouch(gesture:)))
         window?.addGestureRecognizer(longPressGesture)
        
        return true
    }
    
    @objc func screenTouch(gesture: UILongPressGestureRecognizer) {
        snowEffect.animate(gesture: gesture)
      }
}
