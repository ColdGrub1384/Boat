//
//  ViewController.swift
//  Boat
//
//  Created by Adrian on 21.05.18.
//  Copyright © 2018 Adrian. All rights reserved.
//

import UIKit
import StoreKit

/// Main View Controller.
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKStoreProductViewControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Cells
    
    let chromeIndexPath = IndexPath(row: 0, section: 0)
    let dolphinIndexPath = IndexPath(row: 1, section: 0)
    let firefoxIndexPath = IndexPath(row: 2, section: 0)
    let operaIndexPath = IndexPath(row: 3, section: 0)
        
    /// Text field for putting an URL or search with Google.
    @IBOutlet weak var textField: UITextField!
    
    /// Table view containing web browsers.
    @IBOutlet weak var browsersTableView: UITableView!
    
    /// Open the URL entered by the user.
    @IBAction func go(_ sender: Any) {
        if UserDefaults.standard.url(forKey: "browser") != nil {
            
            guard let text = textField.text else {
                print("Cannot get `textField` text!")
                return
            }
            
            guard let openLinkViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browser") as? OpenLinkViewController else {
                return
            }
            
            if let url = URL(string: text), let scheme = url.scheme, scheme == "http" || scheme == "https" { // Is http or https URL
                openLinkViewController.url = url
                present(openLinkViewController, animated: true, completion: nil)
            } else if let url = URL(string: text), let urlWithScheme = URL(string: "http://"+text), (url.scheme == nil || url.scheme == "") && url.absoluteString.contains(".") { // Can be an URL with http or https
                openLinkViewController.url = urlWithScheme
                present(openLinkViewController, animated: true, completion: nil)
            } else if let googleURL = URL(string: "https://www.google.com/search?q="+(text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Cannot%20Encode%20Search")) { // Not an URL, search with Google
                openLinkViewController.url = googleURL
                present(openLinkViewController, animated: true, completion: nil)
            }
            
        } else {
            let alert = UIAlertController(title: "Can't open URL!", message: "Please select a web browser above.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        textField.resignFirstResponder()
    }
    
    // MARK: - View controller
    
    /// Reload `browsersTableView`.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        browsersTableView.reloadData()
    }
    
    /// Dismiss keyboard.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    // MARK: - Table view data source
    
    /// - Returns: `4`.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    /// - Returns: `"Default browser"`.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Default browser"
    }
    
    /// Configure the cell.
    ///
    /// - Returns: A configured cell for current index.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "browser")
        
        var browser: WebBrowser?
        var browserIcon: UIImage?
        var browserName: String?
        switch indexPath.row {
        case 0: // Chrome
            browser = kChrome
            browserIcon = #imageLiteral(resourceName: "chrome")
            browserName = "Chrome"
        case 1: // Dolphin
            browser = kDolphin
            browserIcon = #imageLiteral(resourceName: "dolphin")
            browserName = "Dolphin"
        case 2: // Firefox
            browser = kFirefox
            browserIcon = #imageLiteral(resourceName: "firefox")
            browserName = "Firefox"
        case 3: // Opera
            browser = kOpera
            browserIcon = #imageLiteral(resourceName: "opera")
            browserName = "Opera"
        default:
            break
        }
        
        let imageView = (cell?.viewWithTag(1) as? UIImageView)
        imageView?.image = browserIcon
        imageView?.clipsToBounds = true
        imageView?.layer.borderWidth = 0.5
        imageView?.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        imageView?.layer.cornerRadius = 12
        
        (cell?.viewWithTag(2) as? UILabel)?.text = browserName
        
        if let url = browser?.urlScheme, !UIApplication.shared.canOpenURL(url) {
            cell?.alpha = 0.5
            cell?.contentView.alpha = 0.5
        } else {
            cell?.alpha = 1
            cell?.contentView.alpha = 1
        }
        
        if let url = UserDefaults.standard.url(forKey: "browser"), browser?.urlScheme == url {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        
        return cell ?? UITableViewCell(style: .default, reuseIdentifier: nil)
    }

    /// - Returns: `60`.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - Table view delegate
    
    /// Select cell.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var browser: WebBrowser?
        switch indexPath.row {
        case 0: // Chrome
            browser = kChrome
        case 1: // Dolphin
            browser = kDolphin
        case 2: // Firefox
            browser = kFirefox
        case 3: // Opera
            browser = kOpera
        default:
            break
        }
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            UserDefaults.standard.set(nil, forKey: "browser")
            UserDefaults.standard.synchronize()
            tableView.reloadData()
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            return
        }
        
        if let url = browser?.urlScheme {
            if !UIApplication.shared.canOpenURL(url) {
                // App Store
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                let appStore = SKStoreProductViewController()
                appStore.delegate = self
                appStore.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier:browser?.appStoreID ?? ""]) { (loaded, _) in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    if loaded {
                        self.present(appStore, animated: true, completion: nil)
                    }
                }
            } else {
                // Set default browser
                UserDefaults.standard.set(url, forKey: "browser")
                UserDefaults.standard.synchronize()
                tableView.reloadData()
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Store product view controller delegate
    
    /// Dismiss `viewController`.
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        go(textField)
        return true
    }
}
