//
//  Endpoint.swift
//  Dexcom Follower
//
//  Created by James Furlong on 9/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

enum Endpoint {
    case login(String, String)
    case authenticationToken(String)
    case calibrations
    case dataRange
    case devices
    case egvs
    case events
    case statistics
    
    // MARK: - Variables
    
    var path: String {
        switch self {
        case .login(let clientId, let redirctUri): return "v2/oauth2/login?client_id=\(clientId)&redirect_uri=\(redirctUri)&response_type=code&scope=offline_access&state=?"
        case .authenticationToken(let token): return "/v2/oauth2/\(token)"
        default: return "nil"
        }
    }
}
