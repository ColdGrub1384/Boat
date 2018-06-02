//
//  OpenLinkViewController.swift
//  Boat
//
//  Created by Adrian on 26.05.18.
//  Copyright © 2018 Adrian. All rights reserved.
//

import UIKit

/// View controller used to open an URL with the default browser.
class OpenLinkViewController: UIViewController {
    
    /// http or https URL to open.
    var url: URL?
        
    private var browserName = ""
    
    /// Icon of the browser.
    @IBOutlet weak var iconView: UIImageView!
    
    /// The button to open the URL.
    @IBOutlet weak var openButton: UIButton!
    
    /// The label used to display the URL
    @IBOutlet weak var urlLabel: UILabel!
    
    /// Share URL.
    @IBAction func shareURL(_ sender: Any) {
        if let url = url {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: [])
            present(activityVC, animated: true, completion: nil)
        }
    }
    
    /// Open the URL.
    @IBAction func openURL(_ sender: Any) {
        if let url = url {
            UIApplication.shared.open(urlForDefaultBrowser(url), options: [:]) { (success) in
                self.dismiss(animated: true, completion: {
                    if !success {
                        (UIApplication.shared.keyWindow?.rootViewController as? ViewController)?.textField.text = url.absoluteString
                        let alert = UIAlertController(title: Localizable.errorOpeningURL, message: Localizable.browserNotInstalled(self.browserName), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    /// Dismiss.
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: {
            (UIApplication.shared.keyWindow?.rootViewController as? ViewController)?.textField.text = self.url?.absoluteString
        })
    }
    
    // MARK: - View controller
    
    /// Setup views.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        iconView.clipsToBounds = true
        iconView.layer.borderWidth = 0.5
        iconView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        iconView.layer.cornerRadius = 12
        
        openButton.layer.cornerRadius = 6
        openButton.clipsToBounds = true
        
        var browserIcon: UIImage?
        switch defaultBrowser?.urlScheme {
        case kChrome.urlScheme: // Chrome
            browserIcon = #imageLiteral(resourceName: "chrome")
            browserName = "Chrome"
        case kDolphin.urlScheme: // Dolphin
            browserIcon = #imageLiteral(resourceName: "dolphin")
            browserName = "Dolphin"
        case kEdge.urlScheme: // Edge
            browserIcon = #imageLiteral(resourceName: "edge")
            browserName = "Edge"
        case kFirefox.urlScheme: // Firefox
            browserIcon = #imageLiteral(resourceName: "firefox")
            browserName = "Firefox"
        case kOpera.urlScheme: // Opera
            browserIcon = #imageLiteral(resourceName: "opera")
            browserName = "Opera"
        default:
            break
        }
        
        iconView.image = browserIcon
        openButton.setTitle(Localizable.openIn(browserName), for: .normal)
        urlLabel.text = url?.absoluteString
    }
}
