//
//  UIViewController+Extension.swift
//  socialcalendar
//
//  Created by AK on 21/01/25.
//

import UIKit

enum StoryboardType: String {
    case login = "Login"
    case feed = "Feed"
    
    func storyboard() -> UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}

extension UIViewController {
    static func load(from storyboardType: StoryboardType) -> Self {
        return storyboardType.storyboard().instantiateViewController(withIdentifier: String(describing: self)) as! Self
    }
}
