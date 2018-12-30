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
            case .calibrations: return "/v2/users/self/calibrations"
            case .dataRange: return "/v2/users/self/dataRange"
            case .devices: return "/v2/users/self/devices"
            case .egvs: return "/v2/users/self/egvs"
            case .events: return "/v2/users/self/events"
            case .statistics: return "/v2/users/self/statistics"
        }
    }
}
