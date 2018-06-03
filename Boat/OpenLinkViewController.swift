//
//  OpenLinkViewController.swift
//  Boat
//
//  Created by Adrian on 26.05.18.
//  Copyright © 2018 Adrian. All rights reserved.
//

import UIKit
import SafariServices
import GoogleMobileAds
import WebKit

/// View controller used to open an URL with the default browser.
class OpenLinkViewController: UIViewController, WKNavigationDelegate, GADBannerViewDelegate {
    
    /// http or https URL to open.
    var url: URL?
        
    private var browserName = ""
    
    /// Banner view placed at the bottom of `view`.
    var bannerView: GADBannerView!
    
    /// Title of the page.
    @IBOutlet weak var pageTitle: UILabel!
    
    /// URL label.
    @IBOutlet weak var pageURL: UILabel!
    
    /// Blurred Web view in background showing a preview of `url`.
    @IBOutlet weak var backgroundWebView: WKWebView!
    
    /// Icon of the browser.
    @IBOutlet weak var iconView: UIImageView!
    
    /// The button to open the URL.
    @IBOutlet weak var openButton: UIButton!
    
    /// Choose another web browser.
    @IBAction func openIn(_ sender: Any) {
        
        let app = UIApplication.shared
        
        guard let url = url else {
            return
        }
        
        let defaultBrowser_ = defaultBrowser
        
        let actionSheet = UIAlertController(title: Localizable.chooseWebBrowser, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Safari", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: {
                let safari = SFSafariViewController(url: url)
                safari.dismissButtonStyle = .done
                app.keyWindow?.topViewController?.present(safari, animated: true, completion: nil)
            })
        }))
        
        if app.canOpenURL(kChrome.urlScheme) {
            actionSheet.addAction(UIAlertAction(title: "Chrome", style: .default, handler: { (_) in
                defaultBrowser = kChrome
                self.openURL(self)
                defaultBrowser = defaultBrowser_
            }))
        }
        
        if app.canOpenURL(kDolphin.urlScheme) {
            actionSheet.addAction(UIAlertAction(title: "Dolphin", style: .default, handler: { (_) in
                defaultBrowser = kDolphin
                self.openURL(self)
                defaultBrowser = defaultBrowser_
            }))
        }
        
        if app.canOpenURL(kEdge.urlScheme) {
            actionSheet.addAction(UIAlertAction(title: "Edge", style: .default, handler: { (_) in
                defaultBrowser = kEdge
                self.openURL(self)
                defaultBrowser = defaultBrowser_
            }))
        }
        
        if app.canOpenURL(kFirefox.urlScheme) {
            actionSheet.addAction(UIAlertAction(title: "Firefox", style: .default, handler: { (_) in
                defaultBrowser = kFirefox
                self.openURL(self)
                defaultBrowser = defaultBrowser_
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: Localizable.cancel, style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
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
                        alert.addAction(UIAlertAction(title: Localizable.ok, style: .default, handler: nil))
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
            (UIApplication.shared.keyWindow?.rootViewController as? ViewController)?.goButton.isEnabled = true
        })
    }
    
    /// Add given banner view to `view` with constraints.
    ///
    /// - Parameters:
    ///     - bannerView: Banner view to add.
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    // MARK: - View controller
    
    /// Load ad and setup views.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.rootViewController = self
        bannerView.adUnitID = "ca-app-pub-9214899206650515/2565783971"
        bannerView.delegate = self
        bannerView.load(GADRequest())
        
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
        
        if let url = url {
            backgroundWebView.load(URLRequest(url: url))
            backgroundWebView.navigationDelegate = self
        }
        
        if var urlString = url?.absoluteString {
            var urlComponents = urlString.components(separatedBy: "://")
            urlComponents.removeFirst()
            urlString = urlComponents.joined()
            if urlString.hasPrefix("www.") {
                urlString = urlString.components(separatedBy: "www.")[1]
            }
            pageURL.isHidden = false
            pageURL.text = urlString
        }
    }
    
    // MARK: - Navigation delegate
    
    /// Get page title.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.title") { (title, _) in
            if let title = title as? String {
                self.pageTitle.isHidden = false
                self.pageTitle.text = title
            }
        }
    }
    
    // MARK: - Banner view delegate
    
    /// Show ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerViewToView(bannerView)
    }
    
    /// Print error.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error.localizedDescription)
    }
}
