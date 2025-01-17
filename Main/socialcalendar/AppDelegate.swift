//
//  AppDelegate.swift
//  socialcalendar
//
//  Created by AK on 17/01/25.
//

import Firebase
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        // Move to app coordinator
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let rootViewController = storyboard.instantiateInitialViewController()
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()
        return true
    }
}

