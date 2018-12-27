//
//  UIColor+Utilities.swift
//  Dexcom Follower
//
//  Created by James Furlong on 9/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit.UIColor

public extension UIColor {
    public struct RGBA {
        public var red: CGFloat = 0
        public var green: CGFloat = 0
        public var blue: CGFloat = 0
        public var alpha: CGFloat = 0
        
        public init?(color: UIColor) {
            guard color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
                return nil
            }
        }
    }
    
    public struct HSBA {
        public var hue: CGFloat = 0
        public var saturation: CGFloat = 0
        public var brightness: CGFloat = 0
        public var alpha: CGFloat = 0
        
        public init?(color: UIColor) {
            guard color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
                return nil
            }
        }
    }
    
    public var rgba: RGBA? { return RGBA(color: self) }
    public var hsba: HSBA? { return HSBA(color: self) }
    
    // MARK: - Initialisation
    
    convenience init(hex: String) {
        let firstChar: Character = hex[hex.startIndex]
        let stringToParse: String = "#" + hex.suffix(from: firstChar == "#" ? hex.index(after: hex.startIndex) : hex.startIndex)
        
        let scanner = Scanner(string: stringToParse)
        scanner.scanLocation = 1 // skip '#'
        
        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)
        
        let rValue: CGFloat = CGFloat((rgb & 0xFF0000) >> 16)
        let gValue: CGFloat = CGFloat((rgb & 0xFF00) >> 8)
        let bValue: CGFloat = CGFloat(rgb & 0xFF)
        let r: CGFloat = (rValue / 255.0)
        let g: CGFloat = (gValue / 255.0)
        let b: CGFloat = (bValue / 255.0)
        
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
    
    // MARK: - Functions
    
    public func toImage() -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        
        let context = UIGraphicsGetCurrentContext()
        
        setFill()
        
        context?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
