//
//  Endpoint.swift
//  Dexcom Follower
//
//  Created by James Furlong on 9/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

enum Endpoint {
    case login
    case calibrations
    case dataRange
    case devices
    case egvs
    case events
    case statistics
    
    // MARK: - Variables
    
    var path: String {
        switch self {
        case .login: return "v2/oauth2/login?client_id={your_client_id}&redirect_uri={your_redirect_uri}&response_type=code&scope=offline_access&state=?"
        }
    }
}
