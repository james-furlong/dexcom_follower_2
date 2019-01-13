//
//  Environment.swift
//  Dexcom Follower
//
//  Created by James Furlong on 9/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol Environment {
    static var target: TargetEnvironment { get }
    static var session: URLSession { get }
    
    static var httpProtocol: String { get }
    static var baseUrl: String { get }
    static var version: String { get }
    static var apiClient: ApiClientType { get }
    static var authClient: AuthClientType { get }
}

// MARK: - Target

enum TargetEnvironment: Int, CaseIterable {
    case mock
    case staging
    case production
    
    var title: String {
        switch self {
            case .mock: return "Mock"
            case .staging: return "Staging"
            case .production: return "Production"
        }
    }
    
    var environment: Environment.Type {
        switch self {
            case .mock: return MockEnvironment.self
            case .staging: return StagingEnvironment.self
            case .production: return ProductionEnvironment.self
        }
    }
}

// MARK: - Environment Configuration

struct MockEnvironment: Environment {
    static var target: TargetEnvironment = .mock
    static var session: URLSession = URLSession.shared
    
    static var httpProtocol: String = "https"
    static var baseUrl: String = ""
    static var version: String = "1"
    static var apiClient: ApiClientType = Network.ApiClient()
    static var authClient: AuthClientType = Network.AuthClient()
    
}

struct StagingEnvironment: Environment {
    static var target: TargetEnvironment = .staging
    static var session: URLSession = URLSession.shared
    
    static var httpProtocol: String = "https"
    static var baseUrl: String = "sandbox-api.dexcom.com"
    static var version: String = "1"
    static var apiClient: ApiClientType = Network.ApiClient()
    static var authClient: AuthClientType = Network.AuthClient()
}

struct ProductionEnvironment: Environment {
    static var target: TargetEnvironment = .production
    static var session: URLSession = URLSession.shared
    
    static var httpProtocol: String = "https"
    static var baseUrl: String = "api.dexcom.com"
    static var version: String = "1"
    static var apiClient: ApiClientType = Network.ApiClient()
    static var authClient: AuthClientType = Network.AuthClient()
}
