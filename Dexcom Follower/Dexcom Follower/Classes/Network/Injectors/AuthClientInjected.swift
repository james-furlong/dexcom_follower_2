//
//  AuthClientInjected.swift
//  Dexcom Follower
//
//  Created by James Furlong on 14/1/19.
//  Copyright © 2019 James Furlong. All rights reserved.
//

protocol AuthClientInjected {}

extension AuthClientInjected {
    var authClient: AuthClientType { return Injector.Env.authClient }
}
