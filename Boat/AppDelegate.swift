//
//  AppDelegate.swift
//  Boat
//
//  Created by Adrian on 21.05.18.
//  Copyright © 2018 Adrian. All rights reserved.
//

import UIKit

/// The application delegate.
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    /// Reload `ViewController.browsersTableView`.
    func applicationDidBecomeActive(_ application: UIApplication) {
        (application.keyWindow?.rootViewController as? ViewController)?.browsersTableView.reloadData()
    }
    
    /// Open URL with default browser.
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if UserDefaults.standard.url(forKey: "browser") != nil {
            guard let openLinkViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browser") as? OpenLinkViewController else {
                return false
            }
            
            openLinkViewController.url = url
            UIApplication.shared.keyWindow?.topViewController?.present(openLinkViewController, animated: true, completion: nil)
        } else {
            (app.keyWindow?.rootViewController as? ViewController)?.textField.text = url.absoluteString
        }
        
        return true
    }
}

