//
//  DevicesResponse.swift
//  Dexcom Follower
//
//  Created by James Furlong on 31/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import Foundation

struct DeviceResponse: Hashable {
    let devices: [Devices]
}

struct Devices: Hashable {
    let transmitterGeneration: String?
    let displayDevice: String?
    let lastUploadDate: Date
    let alertScheduleList: [AlertScheduleList]
}

struct AlertScheduleList: Hashable {
    let alertScheduleSettings: AlertScheduleSettings
    let alertSettings: [AlertSettings]?
}

struct AlertScheduleSettings: Hashable {
    let alertScheduleName: String
    let isEnabled: Bool
    let isDefaultSchedule: Bool
    let startTime: Date
    let endTime: Date
    let daysOfWeek: [String]
}

struct AlertSettings: Hashable {
    let alertName: String
    let value: Float?
    let unit: String?
    let snooze: Int?
    let enable: Bool
    let systemTime: Date
    let displayTime: Date
}

// MARK: Codable

extension DeviceResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case devices
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self = DeviceResponse(devices: try container.decode([Devices].self, forKey: .devices))
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(devices, forKey: .devices)
    }
    
    static func defaultResponse() -> DeviceResponse {
        return DeviceResponse(devices: [Devices]())
    }
}

extension Devices: Codable {
    enum CodingKeys: String, CodingKey {
        case transmitterGeneration
        case displayDevice
        case lastUploadDate
        case alertScheduleList
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self = Devices(
            transmitterGeneration: try? container.decode(String.self, forKey: .transmitterGeneration),
            displayDevice: try? container.decode(String.self, forKey: .displayDevice),
            lastUploadDate: try container.decode(Date.self, forKey: .lastUploadDate),
            alertScheduleList: try container.decode([AlertScheduleList].self, forKey: .alertScheduleList)
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)
        
        if let transmitterGeneration: String = transmitterGeneration {
            try container.encode(transmitterGeneration, forKey: .transmitterGeneration)
        }
        
        if let displayDevice: String = displayDevice {
            try container.encode(displayDevice, forKey: .displayDevice)
        }
        
        try container.encode(lastUploadDate, forKey: .lastUploadDate)
        try container.encode(alertScheduleList, forKey: .alertScheduleList)
    }
    
}

extension AlertScheduleList: Codable {
    enum CodingKeys: String, CodingKey {
        case alertScheduleSettings
        case alertSettings
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self = AlertScheduleList(
            alertScheduleSettings: try container.decode(AlertScheduleSettings.self, forKey: .alertScheduleSettings),
            alertSettings: try? container.decode([AlertSettings].self, forKey: .alertSettings)
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alertScheduleSettings, forKey: .alertScheduleSettings)
        try container.encode(alertSettings, forKey: .alertSettings)
    }
}

extension AlertScheduleSettings: Codable {
    enum CodingKeys: String, CodingKey {
        case alertScheduleName
        case isEnabled
        case isDefaultSchedule
        case startTime
        case endTime
        case daysOfWeek
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self = AlertScheduleSettings(
            alertScheduleName: try container.decode(String.self, forKey: .alertScheduleName),
            isEnabled: try container.decode(Bool.self, forKey: .isEnabled),
            isDefaultSchedule: try container.decode(Bool.self, forKey: .isDefaultSchedule),
            startTime: try container.decode(Date.self, forKey: .startTime),
            endTime: try container.decode(Date.self, forKey: .endTime),
            daysOfWeek: try container.decode([String].self, forKey: .daysOfWeek)
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alertScheduleName, forKey: .alertScheduleName)
        try container.encode(isEnabled, forKey: .isEnabled)
        try container.encode(isDefaultSchedule, forKey: .isDefaultSchedule)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(daysOfWeek, forKey: .daysOfWeek)
    }
}

extension AlertSettings: Codable {
    enum CodingKeys: String, CodingKey {
        case alertName
        case value
        case unit
        case snooze
        case enable
        case systemTime
        case displayTime
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self = AlertSettings(
            alertName: try container.decode(String.self, forKey: .alertName),
            value: try? container.decode(Float.self, forKey: .value),
            unit: try? container.decode(String.self, forKey: .unit),
            snooze: try? container.decode(Int.self, forKey: .snooze),
            enable: try container.decode(Bool.self, forKey: .enable),
            systemTime: try container.decode(Date.self, forKey: .systemTime),
            displayTime: try container.decode(Date.self, forKey: .displayTime)
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<CodingKeys> = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alertName, forKey: .alertName)
        try container.encode(value, forKey: .value)
        try container.encode(unit, forKey: .unit)
        try container.encode(snooze, forKey: .snooze)
        try container.encode(enable, forKey: .enable)
        try container.encode(systemTime, forKey: .systemTime)
        try container.encode(displayTime, forKey: .displayTime)
    }
}

