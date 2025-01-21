//
//  AppDelegate.swift
//  socialcalendar
//
//  Created by AK on 17/01/25.
//

import FirebaseAuth
import FirebaseCore
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var coordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        coordinator = AppCoordinator(window: UIWindow(frame: UIScreen.main.bounds))
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return Auth.auth().canHandle(url)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        print("app delegate=====\(userActivity.webpageURL?.absoluteString ?? "NO WEBPAGE URL")")
        return true
    }
}

