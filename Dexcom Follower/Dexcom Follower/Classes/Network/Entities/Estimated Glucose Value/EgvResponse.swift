//
//  EgvResponse.swift
//  Dexcom Follower
//
//  Created by James Furlong on 31/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import Foundation

struct EgvResponse: Hashable {
    let unit: String
    let rateUnit: String
    let egvs: [EGVS]
}

struct EGVS: Hashable {
    let systemTime: Date
    let displayTime: Date
    let value: Float
    let realtimeValue: Float
    let smoothedValue: Float
    let trend: String
    let trendRate: Float
}

extension EgvResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case unit = "unit"
        case rateUnit = "rateUnit"
        case egvs = "egvs"
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        
        self = EgvResponse(
            unit: try container.decode(String.self, forKey: .unit),
            rateUnit: try container.decode(String.self, forKey: .rateUnit),
            egvs: try container.decode([EGVS].self, forKey: .egvs)
        )
    }
}

extension EGVS: Decodable {
    enum CodingKeys: String, CodingKey {
        case systemTime = "systemTime"
        case displayTime = "displayTime"
        case value = "value"
        case realtimeValue = "realtimeValue"
        case smoothedValue = "smoothedValue"
        case trend = "trend"
        case trendRate = "trendRate"
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        
        self = EGVS(
            systemTime: try container.decode(Date.self, forKey: .systemTime),
            displayTime: try container.decode(Date.self, forKey: .displayTime),
            value: try container.decode(Float.self, forKey: .value),
            realtimeValue: try container.decode(Float.self, forKey: .realtimeValue),
            smoothedValue: try container.decode(Float.self, forKey: .smoothedValue),
            trend: try container.decode(String.self, forKey: .trend),
            trendRate: try container.decode(Float.self, forKey: .trendRate)
        )
    }
}
