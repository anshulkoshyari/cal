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
    private var isFirstLaunch: Bool {
        return !UserDefaults.standard.bool(forKey: "IsFirstLaunch")
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        clearKeychainIfNeeded()
        FirebaseApp.configure()
        
        coordinator = AppCoordinator(window: UIWindow(frame: UIScreen.main.bounds))
        return true
    }
    
    private func clearKeychainIfNeeded() {
        guard isFirstLaunch else { return }
        UserDefaults.standard.set(true, forKey: "IsFirstLaunch")
        clearKeychain()
    }

    private func clearKeychain() {
        let secItemClasses = [
            kSecClassGenericPassword,
            kSecClassInternetPassword,
            kSecClassCertificate,
            kSecClassKey,
            kSecClassIdentity
        ]
        for secItemClass in secItemClasses {
            let query: [String: Any] = [kSecClass as String: secItemClass]
            SecItemDelete(query as CFDictionary)
        }
        print("CM: Keychain cleared on first launch.")
    }

    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return Auth.auth().canHandle(url)
    }
}

