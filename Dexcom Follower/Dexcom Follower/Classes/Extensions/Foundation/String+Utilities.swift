//
//  String+Utilities.swift
//  Dexcom Follower
//
//  Created by James Furlong on 13/1/19.
//  Copyright © 2019 James Furlong. All rights reserved.
//

import UIKit

public extension String {
    public var normalized: String {
        return components(separatedBy: .whitespacesAndNewlines).joined()
    }
    
    public func removingAllOccurrences(of substring: String) -> String {
        return replacingOccurrences(of: substring, with: "")
    }
    
    public var localized: String {
        let localizedString = NSLocalizedString(self, comment: "")
        
        guard localizedString != self else {
            fatalError("Key \"\(self)\" is not set in Localizable.strings")
        }
        
        return localizedString
    }
    
    public func localized(with arguments: CVarArg...) -> String {
        return self.localized.formatted(with: arguments)
    }
    
    public func formatted(with arguments: CVarArg...) -> String {
        return String(format: self, arguments: arguments)
    }
    
    public func formatted(with arguments: [CVarArg]) -> String {
        return String(format: self, arguments: arguments)
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    var containsWhitespace: Bool {
        return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
}

extension String {
    func size(withSystemFontSize pointSize: CGFloat) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: pointSize)])
    }
}

