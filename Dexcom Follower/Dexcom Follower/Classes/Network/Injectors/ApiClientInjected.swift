//
//  ApiClientInjected.swift
//  Dexcom Follower
//
//  Created by James Furlong on 31/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

protocol ApiClientInjected {}

extension ApiClientInjected {
    var apiClient: ApiClientType { return Injector.Env.apiClient }
}
