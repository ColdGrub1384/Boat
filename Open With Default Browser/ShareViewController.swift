//
//  ShareViewController.swift
//  Open With Default Browser
//
//  Created by Adrian on 27.05.18.
//  Copyright © 2018 Adrian. All rights reserved.
//

import UIKit
import UserNotifications
import MobileCoreServices

/// View controller used to open an URL from share extension.
class ShareViewController: UIViewController {

    /// Button to complete the request.
    @IBOutlet weak var doneButton: UIButton!
    
    /// A label showing an error.
    @IBOutlet weak var messageLabel: UILabel!
    
    /// An activity indicator at the middle.
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /// Complete request.
    @IBAction func done(_ sender: Any) {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
    
    /// Send notification for opening given URL.
    ///
    /// - Parameters:
    ///     - url: URL to open.
    func sendNotification(withURL url: URL) {
        
        func set(notification: UNMutableNotificationContent, icon: String) {
            if let icon = try? UNNotificationAttachment(identifier: "icon", url: Bundle(for: ShareViewController.self).bundleURL.appendingPathComponent(icon), options: nil) {
                notification.attachments = [icon]
            }
        }
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = Localizable.openIn("Boat")
        if let defaultBrowser = defaultBrowser {
            switch defaultBrowser.urlScheme {
            case kChrome.urlScheme:
                notificationContent.title = Localizable.openIn("Chrome")
                set(notification: notificationContent, icon: "chrome.png")
            case kDolphin.urlScheme:
                notificationContent.title = Localizable.openIn("Dolphin")
                set(notification: notificationContent, icon: "dolphin.png")
            case kFirefox.urlScheme:
                notificationContent.title = Localizable.openIn("Firefox")
                set(notification: notificationContent, icon: "firefox.jpeg")
            case kOpera.urlScheme:
                notificationContent.title = Localizable.openIn("Opera")
                set(notification: notificationContent, icon: "opera.jpeg")
            default:
                break
            }
        }
        notificationContent.body = url.absoluteString
        
        let request = UNNotificationRequest(identifier: "openURL", content: notificationContent, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false))
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // MARK: - View controller
    
    /// Send notification for opening URLS.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized || settings.alertSetting == .disabled {
                self.doneButton.isHidden = false
                self.activityIndicator.isHidden = true
                self.messageLabel.isHidden = false
                self.messageLabel.text = Localizable.enableNotificationsAlert
                return
            }
        }
        
        guard let items = extensionContext?.inputItems as? [NSExtensionItem] else {
            extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            return
        }
        
        var isValid = false
        var wasLoaded = false
        for item in items {
            if let itemProviders = item.attachments as? [NSItemProvider] {
                for itemProvider in itemProviders {
                    if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
                        itemProvider.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil) { (data, _) in
                            wasLoaded = true
                            if let string = data as? String, let url = URL(string: string), url.scheme == "http" || url.scheme == "https" {
                                isValid = true
                                self.sendNotification(withURL: url)
                            }
                        }
                    } else if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                        itemProvider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil) { (data, _) in
                            wasLoaded = true
                            if let url = data as? URL, url.scheme == "http" || url.scheme == "https" {
                                isValid = true
                                self.sendNotification(withURL: url)
                            }
                        }
                    } else {
                        wasLoaded = true
                    }
                }
            } else {
                wasLoaded = true
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            while !wasLoaded {
                sleep(UInt32(0.1))
            }
            
            DispatchQueue.main.async {
                if isValid {
                    self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                } else {
                    self.doneButton.isHidden = false
                    self.activityIndicator.isHidden = true
                    self.messageLabel.isHidden = false
                    self.messageLabel.text = Localizable.invalidURL
                }
            }
        }
    }

}
