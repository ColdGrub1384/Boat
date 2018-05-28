//
//  Browser.swift
//  Boat
//
//  Created by Adrian on 21.05.18.
//  Copyright © 2018 Adrian. All rights reserved.
//

import Foundation

/// A web browser.
struct WebBrowser {
    
    /// URL scheme for opening the app.
    var urlScheme: URL
    
    /// The App Store ID to download the app.
    var appStoreID: String
}

/// Get url for default browser.
/// - Returns: An URL to be opened with the default browser.
func urlForDefaultBrowser(_ url: URL) -> URL {
    if let browserURL = defaultBrowser?.urlScheme {
        
        var components = url.absoluteString.components(separatedBy: "://")
        components.removeFirst()
        let urlWithoutScheme = components.joined(separator: "")
        
        var urlToOpen_: URL? {
            if browserURL != kFirefox.urlScheme {
                return URL(string: browserURL.absoluteString+urlWithoutScheme)
            } else {
                return URL(string: browserURL.absoluteString+url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            }
        }
        
        if let urlToOpen = urlToOpen_ {
            return urlToOpen
        } else {
            return url
        }
    } else {
        return url
    }
}

let kChrome = WebBrowser(urlScheme: URL(string: "googlechrome://")!, appStoreID: "535886823")
let kDolphin = WebBrowser(urlScheme: URL(string: "dolphin://")!, appStoreID: "634693702")
let kFirefox = WebBrowser(urlScheme: URL(string: "firefox://open-url?url=")!, appStoreID: "989804926")
let kOpera = WebBrowser(urlScheme: URL(string: "opera-http://")!, appStoreID: "363729560")

/// Returns the default browser or sets the default browser.
var defaultBrowser: WebBrowser? {
    
    get {
        if let url = UserDefaults(suiteName: "group.Boat")?.url(forKey: "browser") {
            switch url {
            case kChrome.urlScheme:
                return kChrome
            case kDolphin.urlScheme:
                return kDolphin
            case kFirefox.urlScheme:
                return kFirefox
            case kOpera.urlScheme:
                return kOpera
            default:
                break
            }
        }
        
        return nil
    }
    
    set {
        UserDefaults(suiteName: "group.Boat")?.set(newValue?.urlScheme, forKey: "browser")
        UserDefaults(suiteName: "group.Boat")?.synchronize()
    }
}
