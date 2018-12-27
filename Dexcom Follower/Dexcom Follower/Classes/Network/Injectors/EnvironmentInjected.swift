//
//  EnvironmentInjected.swift
//  Dexcom Follower
//
//  Created by James Furlong on 9/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import Foundation

private let defaultEnvironment: Environment.Type = {
    func getDefaultEnvironment() -> Environment.Type {
        var appDefaults: [String: Any] = [:]
        appDefaults[settingsBundleAPIKey] = TargetEnvironment.staging.rawValue
        UserDefaults.standard.register(defaults: appDefaults)
        UserDefaults.standard.synchronize()
        
        let rawValue: Int = UserDefaults.standard.integer(forKey: settingsBundleAPIKey)
        return (TargetEnvironment(rawValue: rawValue) ?? TargetEnvironment.staging).environment
    }
    
    #if DEBUG
    return getDefaultEnvironment()
    #else
    return ProductionEnvironment.self
    #endif
}()

private let settingsBundleAPIKey: String = "settings-APIEndpoint"

// MARK: - Injector

extension Injector {
    struct Env {
        static var target: TargetEnvironment = defaultEnvironment.target {
            didSet {
                func configure(environment: Environment.Type) {
                    Injector.Env.session = environment.session
                    Injector.Env.httpProtocol = environment.httpProtocol
                    Injector.Env.baseUrl = environment.baseUrl
                    Injector.Env.version = environment.version
                }
            }
        }
        
        static var session: URLSession = defaultEnvironment.session
        static var httpProtocol: String = defaultEnvironment.httpProtocol
        static var baseUrl: String = defaultEnvironment.baseUrl
        static var version: String = defaultEnvironment.version
    }
}

protocol EnvironmentInjected {}

extension EnvironmentInjected {
    var target: TargetEnvironment { return Injector.Env.target }
    var session: URLSession { return Injector.Env.session }
    
    var httpProtocol: String { return Injector.Env.httpProtocol }
    var baseUrl: String { return Injector.Env.baseUrl }
    var version: String { return Injector.Env.version }
}
