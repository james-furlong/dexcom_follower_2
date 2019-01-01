//
//  HTTPHeaders.swift
//  Dexcom Follower
//
//  Created by James Furlong on 28/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import Foundation

typealias HTTPHeaders = [String: String]

enum HTTPHeader: String {
    case contentType = "content-type"
    case cacheControl = "cache-control"
}

