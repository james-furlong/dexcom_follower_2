//
//  Theme.swift
//  Dexcom Follower
//
//  Created by James Furlong on 11/11/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit.UIColor

public struct Theme {
    public struct Font {}
    public struct Color {}
    public struct StringAttributes {}
    public struct Gradients {}
    public struct Constants {}
}

public typealias StringAttributes = [NSAttributedString.Key: Any]
public typealias GradientValues = ([UIColor], CGPoint, CGPoint)

extension UIColor {
    static let azure: UIColor = #colorLiteral(red: 0.2, green: 0.4, blue: 0.6, alpha: 1) // #336699
    static let halfBaked: UIColor = #colorLiteral(red: 0.5254901961, green: 0.7333333333, blue: 0.8470588235, alpha: 1) // #86BBD8
    static let pickledBluewood: UIColor = #colorLiteral(red: 0.1843137255, green: 0.2823529412, blue: 0.3450980392, alpha: 1) // #2F4858
    static let persianGreen: UIColor = #colorLiteral(red: 0, green: 0.6588235294, blue: 0.5882352941, alpha: 1) // #00A896
    static let caribbeanGreen: UIColor = #colorLiteral(red: 0.007843137255, green: 0.7647058824, blue: 0.6039215686, alpha: 1) // #02C39A
}
