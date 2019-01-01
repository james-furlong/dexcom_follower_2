//
//  User.swift
//  Dexcom Follower
//
//  Created by James Furlong on 1/1/19.
//  Copyright © 2019 James Furlong. All rights reserved.
//

import UIKit

struct User: Hashable {
    let name: String?
    let userImage: UIImage?
    let value: Float
    let lastUpdated: String
    let units: String
    let trendArrow: UIImage
}

extension User {
    init(value: Float, lastUpdated: String, units: String, trendArrow: UIImage) {
        self.name = "Hunter Furlong"
        self.userImage = UIImage()
        self.value = value
        self.lastUpdated = lastUpdated
        self.units = units
        self.trendArrow = trendArrow
    }
}
