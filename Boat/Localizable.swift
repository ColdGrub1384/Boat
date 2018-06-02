//
//  Localizable.swift
//  Boat
//
//  Created by Adrian on 30.05.18.
//  Copyright © 2018 Adrian. All rights reserved.
//

import Foundation

/// Localizable strings.
class Localizable {
    private init() {}
    
    /// `"Default Web Browser"`.
    static var defaultWebBrowser: String {
        return NSLocalizedString("Default Web Browser", comment: "")
    }
    
    /// `"Error opening URL!"`.
    static var errorOpeningURL: String {
        return NSLocalizedString("Error opening URL!", comment: "")
    }
    
    /// `"OK"`.
    static var ok: String {
        return NSLocalizedString("OK", comment: "")
    }
        
    /// `"It looks like %@ is not installed."`.
    static func browserNotInstalled(_ browser: String) -> String {
        return NSString(format: NSLocalizedString("It looks like %@ is not installed.", comment: "") as NSString, browser) as String
    }
    
    /// `"Open in %@"`.
    static func openIn(_ browser: String) -> String {
        return NSString(format: NSLocalizedString("Open in %@", comment: "") as NSString, browser) as String
    }
}
