//
//  AppDelegate.swift
//  socialcalendar
//
//  Created by AK on 17/01/25.
//

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
}

