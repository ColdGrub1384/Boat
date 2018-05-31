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
    static let defaultWebBrowser = NSLocalizedString("Default Web Browser", comment: "")
    
    /// `"Error opening URL!"`.
    static let errorOpeningURL = NSLocalizedString("Error opening URL!", comment: "")
        
    /// `"It looks like %@ is not installed."`.
    static func browserNotInstalled(_ browser: String) -> String {
        return NSString(format: NSLocalizedString("Default Web Browser", comment: "") as NSString, browser) as String
    }
    
    /// `"Open in %@"`.
    static func openIn(_ browser: String) -> String {
        return NSString(format: NSLocalizedString("Open in", comment: "") as NSString, browser) as String
    }
}
