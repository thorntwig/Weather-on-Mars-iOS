//
//  APIResponseMapper.swift
//  Weather on Mars
//
//  Created by Robin Törnqvist on 2020-01-23.
//  Copyright © 2020 Robin Törnqvist. All rights reserved.
//

import Foundation

public class APIResponseMapper {
     static func dataMapper(from apiResponse: Data) -> [Sol] {
        var solList = [Sol]()
        do {
            guard let json = try JSONSerialization.jsonObject(with: apiResponse, options: []) as? [String: Any] else { return solList}
            guard let solKeys = json["sol_keys"] as? [String] else { return solList }
            for key in solKeys {
                if var solJson = json[key] as? [String : Any] {
                    solJson["solNumber"] = key
                    let jsonData = try! JSONSerialization.data(withJSONObject: solJson)
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let solObject = try! decoder.decode(Sol.self, from: jsonData)
                    solList.append(solObject)
                }
                
            }
            
        } catch {
            print(error.localizedDescription)
        }
        return solList
    }
    
}

