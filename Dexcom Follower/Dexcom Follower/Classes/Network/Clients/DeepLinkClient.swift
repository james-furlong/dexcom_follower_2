//
//  DeepLinkClient.swift
//  Dexcom Follower
//
//  Created by James Furlong on 31/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import RxSwift

enum DeeplinkType: String, CaseIterable {
    case login
    case error
}

class DeepLinkClient {
    
    let app: UIApplication
    let url: URL
    let options: [UIApplication.OpenURLOptionsKey: Any]
    
    init(app: UIApplication, url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) {
        self.app = app
        self.url = url
        self.options = options
    }
    
    func handleDeepLink() -> (Bool, DeeplinkType) {
        let deeplinkType: DeeplinkType = getDeeplinkType(from: url)
        let parameters = url.queryParameters
        
        switch deeplinkType {
            
            case .login:
                guard let authenticationCode = parameters?.first(where: {$0.key == "code"})?.value else { return (false, .error) }
                KeychainWrapper.shared[KeychainWrapper.authenticationCode] = authenticationCode
            
            case .error:
                return (false, .error)
        }
        return (true, .login)
    }
    
    func getDeeplinkType(from url: URL) -> DeeplinkType {
        guard !url.relativeString.contains("code") else { return .login }
        return .error
    }
    
}
