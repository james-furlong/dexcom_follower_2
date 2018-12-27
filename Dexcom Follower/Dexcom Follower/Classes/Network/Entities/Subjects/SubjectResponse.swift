//
//  SubjectResponse.swift
//  Dexcom Follower
//
//  Created by James Furlong on 8/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import Foundation

struct SubjectResponse: Codable {
    let subjects: [Subject]
    
    init(subjects: [Subject]) {
        self.subjects = subjects
    }
}

struct Subject: Hashable {
    let name: String
    let measurement: String
    let isActive: Bool
}

extension Subject: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case measurement
        case isActive
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        
        self = Subject(
            name: try container.decode(String.self, forKey: .name),
            measurement: try container.decode(String.self, forKey: .measurement),
            isActive: try container.decode(Bool.self, forKey: .isActive)
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(measurement, forKey: .measurement)
        try container.encode(isActive, forKey: .isActive)
    }
}

extension Subject {
    func toDouble(from string: String) -> Double {
        return (string as NSString).doubleValue
    }
}


