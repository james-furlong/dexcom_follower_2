//
//  StatisticsResponse.swift
//  Dexcom Follower
//
//  Created by James Furlong on 31/12/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import Foundation

struct StatisticsResponse: Hashable {
    let hypoglycemiaRisk: String
    let min: Float
    let max: Float
    let mean: Float
    let median: Float
    let variance: Float
    let stdDev: Float
    let sum: Float
    let q1: Float
    let q2: Float
    let q3: Float
    let utilizationPercent: Float
    let meanDailyCalibrations: Float
    let nDays: Int
    let nValues: Int
    let nUrgentLow : Int
    let nBelowRange: Int
    let nWithinRange: Int
    let nAboveRange: Int
    let percentUrgentLow: Float
    let percentBelowRange: Float
    let percentWithinRange: Float
    let percentAboveRange: Float
}

extension StatisticsResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case hypoglycemiaRisk = "hypoglycemiaRisk"
        case min = "min"
        case max = "max"
        case mean = "mean"
        case median = "median"
        case variance = "variance"
        case stdDev = "stdDev"
        case sum = "sum"
        case q1 = "q1"
        case q2 = "q2"
        case q3 = "q3"
        case utilizationPercent = "utilizationPercent"
        case meanDailyCalibrations = "meanDailyCalibrations"
        case nDays = "nDays"
        case nValues = "nValues"
        case nUrgentLow = "nUrgentLow"
        case nBelowRange = "nBelowRange"
        case nWithinRange = "nWithinRange"
        case nAboveRange = "nAboveRange"
        case percentUrgentLow = "percentUrgentLow"
        case percentBelowRange = "percentBelowRange"
        case percentWithinRange = "percentWithinRange"
        case percentAboveRange = "percentAboveRange"
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        
        self = StatisticsResponse(
            hypoglycemiaRisk: try container.decode(String.self, forKey: .hypoglycemiaRisk),
            min: try container.decode(Float.self, forKey: .min),
            max: try container.decode(Float.self, forKey: .max),
            mean: try container.decode(Float.self, forKey: .mean),
            median: try container.decode(Float.self, forKey: .median),
            variance: try container.decode(Float.self, forKey: .variance),
            stdDev: try container.decode(Float.self, forKey: .stdDev),
            sum: try container.decode(Float.self, forKey: .sum),
            q1: try container.decode(Float.self, forKey: .q1),
            q2: try container.decode(Float.self, forKey: .q2),
            q3: try container.decode(Float.self, forKey: .q3),
            utilizationPercent: try container.decode(Float.self, forKey: .utilizationPercent),
            meanDailyCalibrations: try container.decode(Float.self, forKey: .meanDailyCalibrations),
            nDays: try container.decode(Int.self, forKey: .nDays),
            nValues: try container.decode(Int.self, forKey: .nValues),
            nUrgentLow: try container.decode(Int.self, forKey: .nUrgentLow),
            nBelowRange: try container.decode(Int.self, forKey: .nBelowRange),
            nWithinRange: try container.decode(Int.self, forKey: .nWithinRange),
            nAboveRange: try container.decode(Int.self, forKey: .nAboveRange),
            percentUrgentLow: try container.decode(Float.self, forKey: .percentUrgentLow),
            percentBelowRange: try container.decode(Float.self, forKey: .percentBelowRange),
            percentWithinRange: try container.decode(Float.self, forKey: .percentWithinRange),
            percentAboveRange: try container.decode(Float.self, forKey: .percentAboveRange)
        )
    }
}
