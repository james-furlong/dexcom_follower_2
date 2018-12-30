//
//  TokenResponse.swift
//  Dexcom Follower
//
//  Created by James Furlong on 28/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import Foundation

struct TokenResponse: Hashable {
    let accessToken: String
    let expiresIn: Int
    let tokenType: String
    let refreshToken: String
}

// MARK: Codable

extension TokenResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case accessToken
        case expiresIn
        case tokenType
        case refreshToken
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        
        self = TokenResponse(
            accessToken: try container.decode(String.self, forKey: .accessToken),
            expiresIn: try container.decode(Int.self, forKey: .expiresIn),
            tokenType: try container.decode(String.self, forKey: .tokenType),
            refreshToken: try container.decode(String.self, forKey: .refreshToken)
        )
    }
    
    static func defaultResponse() -> TokenResponse {
        return TokenResponse(accessToken: "", expiresIn: 0, tokenType: "", refreshToken: "")
    }
}
