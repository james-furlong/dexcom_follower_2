//
//  CGPoint+Utilities.swift
//  Dexcom Follower
//
//  Created by James Furlong on 16/1/19.
//  Copyright © 2019 James Furlong. All rights reserved.
//

import UIKit

extension CGPoint {
    func adding(x: CGFloat) -> CGPoint { return CGPoint(x: self.x + x, y: self.y) }
    func adding(y: CGFloat) -> CGPoint { return CGPoint(x: self.x, y: self.y + y) }
}
