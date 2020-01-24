//
//  SolListUtility.swift
//  Weather on Mars
//
//  Created by Robin Törnqvist on 2020-01-23.
//  Copyright © 2020 Robin Törnqvist. All rights reserved.
//

import Foundation

class SolListUtility {
    
    static func sortByDate(solList: [Sol]) -> [Sol] {
        return solList.sorted(by: { ($0.firstUTC.compare($1.firstUTC) == .orderedDescending )})
    }
}
