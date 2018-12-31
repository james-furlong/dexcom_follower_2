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
    let transmitterGeneration: String
    let displayDevice: String
    let lastUploadDate: Date
    let alertScheduleList: [AlertScheduleList]
}

struct AlertScheduleList: Hashable {
    let alertScheduleSettings: AlertScheduleSettings
    let alertSettings: [AlertSettings]
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
    let value: Float
    let unit: Float
    let snooze: Int
    let enable: Bool
    let systemTime: Date
    let displayTime: Date
}

// MARK: Codable

extension DeviceResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case devices = "devices"
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self = DeviceResponse(devices: try container.decode([Devices].self, forKey: .devices))
    }
    
    static func defaultResponse() -> DeviceResponse {
        return DeviceResponse(devices: [Devices]())
    }
}

extension Devices: Decodable {
    enum CodingKeys: String, CodingKey {
        case transmitterGeneration = "transmitterGeneration"
        case displayDevice = "displayDevice"
        case lastUploadDate = "lastUploadDate"
        case alertScheduleList = "alertScheduleList"
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self = Devices(
            transmitterGeneration: try container.decode(String.self, forKey: .transmitterGeneration),
            displayDevice: try container.decode(String.self, forKey: .displayDevice),
            lastUploadDate: try container.decode(Date.self, forKey: .lastUploadDate),
            alertScheduleList: try container.decode([AlertScheduleList].self, forKey: .alertScheduleList)
        )
    }
}

extension AlertScheduleList: Decodable {
    enum CodingKeys: String, CodingKey {
        case alertScheduleSettings = "alertScheduleSettings"
        case alertSettings = "alertSettings"
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self = AlertScheduleList(
            alertScheduleSettings: try container.decode(AlertScheduleSettings.self, forKey: .alertScheduleSettings),
            alertSettings: try container.decode([AlertSettings].self, forKey: .alertSettings)
        )
    }
}

extension AlertScheduleSettings: Decodable {
    enum CodingKeys: String, CodingKey {
        case alertScheduleName = "alertScheduleName"
        case isEnabled = "isEnabled"
        case isDefaultSchedule = "isDefaultScheduler"
        case startTime = "startTime"
        case endTime = "endTime"
        case daysOfWeek = "daysOfWeek"
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
}

extension AlertSettings: Decodable {
    enum CodingKeys: String, CodingKey {
        case alertName = "alertName"
        case value = "value"
        case unit = "unit"
        case snooze = "snooze"
        case enable = "enable"
        case systemTime = "systemTime"
        case displayTime = "displayTime"
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self = AlertSettings(
            alertName: try container.decode(String.self, forKey: .alertName),
            value: try container.decode(Float.self, forKey: .value),
            unit: try container.decode(Float.self, forKey: .unit),
            snooze: try container.decode(Int.self, forKey: .snooze),
            enable: try container.decode(Bool.self, forKey: .enable),
            systemTime: try container.decode(Date.self, forKey: .systemTime),
            displayTime: try container.decode(Date.self, forKey: .displayTime)
        )
    }
}

