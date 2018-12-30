//
//  CalibrationsResponse.swift
//  Dexcom Follower
//
//  Created by James Furlong on 31/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import Foundation

struct CalibrationsResponse: Hashable {
    let calibrations: [Calibrations]
}

struct Calibrations: Hashable {
    let systemTime: Date
    let displayTime: Date
    let value: Float
    let unit: String
}

extension CalibrationsResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case calibrations = "calibrations"
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self = CalibrationsResponse(calibrations: try container.decode([Calibrations].self, forKey: .calibrations))
    }
}

extension Calibrations: Decodable {
    enum CodingKeys: String, CodingKey {
        case systemTime = "systemTime"
        case displayTime = "displayTime"
        case value = "value"
        case unit = "unit"
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self = Calibrations(
            systemTime: try container.decode(Date.self, forKey: .systemTime),
            displayTime: try container.decode(Date.self, forKey: .displayTime),
            value: try container.decode(Float.self, forKey: .value),
            unit: try container.decode(String.self, forKey: .unit))
    }
}
