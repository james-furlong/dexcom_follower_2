//
//  AuthClient.swift
//  Dexcom Follower
//
//  Created by James Furlong on 28/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import RxSwift

protocol AuthClientType: EnvironmentInjected {
    var hasLoggedInUser: Bool { get }
    
    func accessToken() -> Single<String>
}

extension Network {
    struct AuthClient: AuthClientType {
        
        var hasLoggedInUser: Bool {
            return (
                KeychainWrapper.shared[KeychainWrapper.authenticationToken] != nil &&
                KeychainWrapper.shared[KeychainWrapper.refreshToken] != nil
            )
        }
        
        func accessToken() -> Single<String> {
            return Single.create { single -> Disposable in
                guard let token: String = KeychainWrapper.shared[KeychainWrapper.authenticationToken] else {
                    single(.error(NetworkError.authentication))
                    return Disposables.create()
                }
                
                single(.success(token))
                return Disposables.create()
            }
        }
    }
}



extension KeychainWrapper {
    static let authenticationCode: String = "534886da941e8a9efecc40f726c73973"
    static let authenticationToken: String = "a40a8c4876c2287be9a2f7a7c0e116a0"
    static let refreshToken: String = "sRHk1EHg2LoszE9b1cwCCdvnEVqoQi"
}
