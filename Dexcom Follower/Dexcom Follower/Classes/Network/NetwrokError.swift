//
//  NetwrokError.swift
//  Dexcom Follower
//
//  Created by James Furlong on 14/1/19.
//  Copyright © 2019 James Furlong. All rights reserved.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidUrl
    case invalidMethod
    case noNetwork
    case timeOut
    case api
    case invalidData
    case parsing
    case authentication
    case request(error: Error)
    case invalidBearerToken
    case invalidRefreshToken
    case accountLocked
    
    static func == (left: NetworkError, right: NetworkError) -> Bool {
        switch (left, right) {
        case (.invalidUrl, .invalidUrl): return true
        case (.noNetwork, .noNetwork): return true
        case (.timeOut, .timeOut): return true
        case (.api, .api): return true
        case (.invalidData, .invalidData): return true
        case (.parsing, .parsing): return true
        case (.authentication, .authentication): return true
            
        case (.request(error: let left), .request(error: let right)):
            return (left as NSError) == (right as NSError)
            
        case (.invalidBearerToken, .invalidBearerToken): return true
        case (.accountLocked, .accountLocked): return true
            
        default: return false
        }
    }
}

extension NetworkError {
    init(error: NSError) {
        switch error.code {
            case NSURLErrorTimedOut: self = .timeOut
            case NSURLErrorNotConnectedToInternet: self = .noNetwork
            default: self = .api
        }
    }
    
    init?(statusCode: Int?, data: Data?) {
        guard let statusCode: Int = statusCode, statusCode < 200 || statusCode >= 300 else {
            return nil
        }
        
        // TODO: Handle more codes
        switch statusCode {
            case 401: self = .invalidBearerToken
            case 400: self = .invalidRefreshToken
            default: self = .api
        }
    }
}
