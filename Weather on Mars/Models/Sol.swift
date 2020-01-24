//
//  Sol.swift
//  Weather on Mars
//
//  Created by Robin Törnqvist on 2020-01-13.
//  Copyright © 2020 Robin Törnqvist. All rights reserved.
//

import Foundation
// MARK: - SolClass
struct Sol: Codable {
    let solNumber: String?
    let firstUTC: Date
    let lastUTC: Date?
    let at: At?
    let hws: At?
    let pre: At?
    let season: String?
    
    enum CodingKeys: String, CodingKey {
        case solNumber
        case firstUTC = "First_UTC"
        case lastUTC = "Last_UTC"
        case at = "AT"
        case hws = "HWS"
        case pre = "PRE"
        case season = "Season"
    }
    
    static func convertToCelsius(fahrenheit: Double) -> Double {
        return (fahrenheit - 32) * 5/9
    }
}

// MARK: - At
struct At: Codable {
    let average: Double?
    let ct: Int?
    let min, max: Double?

    enum CodingKeys: String, CodingKey {
        case average = "av"
        case min = "mn"
        case max = "mx"
        case ct
    }
}


