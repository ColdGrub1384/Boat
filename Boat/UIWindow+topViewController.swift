//
//  UIWindow+topViewController.swift
//  Boat
//
//  Created by Adrian on 27.05.18.
//  Copyright © 2018 Adrian. All rights reserved.
//

import UIKit

extension UIWindow {
    
    /// The top view controller on the window.
    var topViewController: UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}
