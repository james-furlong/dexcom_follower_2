//
//  UIImage+Utilities.swift
//  Dexcom Follower
//
//  Created by James Furlong on 3/1/19.
//  Copyright © 2019 James Furlong. All rights reserved.
//

import UIKit

extension UIImage {
    class func imageWithColor(color: UIColor, height: CGFloat, width: CGFloat) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
