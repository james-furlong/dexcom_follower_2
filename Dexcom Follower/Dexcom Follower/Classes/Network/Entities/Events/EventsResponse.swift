//
//  EventsResponse.swift
//  Dexcom Follower
//
//  Created by James Furlong on 31/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import Foundation

struct EventsResponse: Hashable {
    let events: [Event]
}

struct Event: Hashable {
    let systemTime: Date
    let displayTime: Date
    let eventType: String
    let eventSubType: String
    let value: Float
    let unit: String
    let eventId: String
    let eventStatus: String
}

extension EventsResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case events = "events"
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        
        self = EventsResponse(events: try container.decode([Event].self, forKey: .events))
    }
}

extension Event: Decodable {
    enum CodingKeys: String, CodingKey {
        case systemTime = "systemTime"
        case displayTime = "displayTime"
        case eventType = "eventType"
        case eventSubType = "eventSubType"
        case value = "value"
        case unit = "unit"
        case eventId = "eventId"
        case eventStatus = "eventStatus"
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        
        self = Event(
            systemTime: try container.decode(Date.self, forKey: .systemTime),
            displayTime: try container.decode(Date.self, forKey: .displayTime),
            eventType: try container.decode(String.self, forKey: .eventType),
            eventSubType: try container.decode(String.self, forKey: .eventSubType),
            value: try container.decode(Float.self, forKey: .value),
            unit: try container.decode(String.self, forKey: .unit),
            eventId: try container.decode(String.self, forKey: .eventId),
            eventStatus: try container.decode(String.self, forKey: .eventStatus)
        )
    }
}
