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

struct EGVS: Hashable, Equatable {
    let systemTime: Date
    let displayTime: Date
    let value: Float
    let realtimeValue: Float
    let smoothedValue: Float?
    let status: String?
    let trend: String?
    let trendRate: Float?
}

extension EgvResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case unit
        case rateUnit
        case egvs
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        
        self = EgvResponse(
            unit: try container.decode(String.self, forKey: .unit),
            rateUnit: try container.decode(String.self, forKey: .rateUnit),
            egvs: try container.decode([EGVS].self, forKey: .egvs)
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(unit, forKey: .unit)
        try container.encode(rateUnit, forKey: .rateUnit)
        try container.encode(egvs, forKey: .egvs)
    }
    
    static func defaultResponse() -> EgvResponse {
        return EgvResponse(unit: "mmol/L", rateUnit: "mmol/L/min", egvs: [EGVS]())
    }
}

extension EGVS: Codable {
    enum CodingKeys: String, CodingKey {
        case systemTime
        case displayTime
        case value
        case realtimeValue
        case smoothedValue
        case status
        case trend
        case trendRate
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        
        self = EGVS(
            systemTime: try container.decode(Date.self, forKey: .systemTime),
            displayTime: try container.decode(Date.self, forKey: .displayTime),
            value: try container.decode(Float.self, forKey: .value),
            realtimeValue: try container.decode(Float.self, forKey: .realtimeValue),
            smoothedValue: try? container.decode(Float.self, forKey: .smoothedValue),
            status: try? container.decode(String.self, forKey: .status),
            trend: try? container.decode(String.self, forKey: .trend),
            trendRate: try? container.decode(Float.self, forKey: .trendRate)
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(systemTime, forKey: .systemTime)
        try container.encode(displayTime, forKey: .displayTime)
        try container.encode(value, forKey: .value)
        try container.encode(realtimeValue, forKey: .realtimeValue)
        try container.encode(smoothedValue, forKey: .smoothedValue)
        try container.encode(trend, forKey: .trend)
        try container.encode(trendRate, forKey: .trendRate)
    }
    
}
