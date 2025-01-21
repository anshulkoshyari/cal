//
//  AppCoordinator.swift
//  socialcalendar
//
//  Created by AK on 21/01/25.
//

import Combine
import FirebaseAuth
import UIKit

enum RootScene {
    case login
    case feed(User)
}


class AppCoordinator {
    private var window: UIWindow
    private var rootScene: RootScene
    
    init(window: UIWindow) {
        self.window = window
        if let user = Auth.auth().currentUser {
            self.rootScene = .feed(user)
        } else {
            self.rootScene = .login
        }
        start()
    }
    
    private func start() {
        window.rootViewController = create(scene: rootScene)
        window.makeKeyAndVisible()
    }
    
    private func create(scene: RootScene) -> UIViewController {
        switch scene {
        case .login:
            print("CM: Set root window to login screen.")
            let controller: LoginViewController = .load(from: .login)
            return UINavigationController(rootViewController: controller)
            
        case .feed(let user):
            print("CM: Set root window to feed screen.")
            // let controller: FeedViewController = .load(from: .feed)
            let controller = UIViewController()
            controller.view.backgroundColor = .green
            return UINavigationController(rootViewController: controller)
        }
    }
}
