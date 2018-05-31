//
//  AppDelegate.swift
//  Boat
//
//  Created by Adrian on 21.05.18.
//  Copyright © 2018 Adrian. All rights reserved.
//

import UIKit
import UserNotifications
import SafariServices

/// The application delegate.
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    /// Request authorization for notifications.
    func applicationDidFinishLaunching(_ application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert], completionHandler: { _, _ in })
        UNUserNotificationCenter.current().delegate = self
    }

    /// Reload `ViewController.browsersTableView`.
    func applicationDidBecomeActive(_ application: UIApplication) {
        (application.keyWindow?.rootViewController as? ViewController)?.browsersTableView.reloadData()
    }
    
    /// Open URL with default browser.
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if defaultBrowser != nil {
            guard let openLinkViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browser") as? OpenLinkViewController else {
                return false
            }
            
            openLinkViewController.url = url
            UIApplication.shared.keyWindow?.topViewController?.present(openLinkViewController, animated: true, completion: nil)
        } else {
            let safari = SFSafariViewController(url: url)
            safari.dismissButtonStyle = .done
            UIApplication.shared.keyWindow?.topViewController?.present(safari, animated: true, completion: nil)
        }
        
        return true
    }
    
    // MARK: - User notification center delegate
    
    /// Open URL from notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let url = URL(string: response.notification.request.content.body) {
            _ = application(UIApplication.shared, open: url, options: [:])
        }
        completionHandler()
    }
}

