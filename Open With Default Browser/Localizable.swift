//
//  Localizable.swift
//  Open With Default Browser
//
//  Created by Adrian on 31.05.18.
//  Copyright © 2018 Adrian. All rights reserved.
//

import Foundation

/// Localizable strings.
class Localizable {
    private init() {}
    
    /// `"Invalid URL!"`.
    static var invalidURL: String {
        return NSLocalizedString("Invalid URL!", comment: "")
    }
    
    /// `"Please enable notifications alerts from settings."`.
    static var enableNotificationsAlert: String {
        return NSLocalizedString("Please enable notifications alerts from settings.", comment: "")
    }
    
    /// `"Open in %@"`.
    static func openIn(_ browser: String) -> String {
        return NSString(format: NSLocalizedString("Open in %@", comment: "") as NSString, browser) as String
    }
}
