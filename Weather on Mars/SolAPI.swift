//
//  JSONparser.swift
//  Weather on Mars
//
//  Created by Robin Törnqvist on 2020-01-13.
//  Copyright © 2020 Robin Törnqvist. All rights reserved.
//

import Foundation

final class SolAPI {

    static let shared = SolAPI()
    
    func fetchSolList(router: Router, onCompletion: @escaping ([SolClass]) ->()) {
        var solList = [SolClass]()
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters
        
        guard let url = components.url else { return }
        URLSession.shared.dataTask(with: url) { data, reponse, error in
            if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
                       
                    guard let solKeys = json["sol_keys"] as? [String] else { return }
                        
                    for key in solKeys {
                        if var solJson = json[key] as? [String : Any] {
                            solJson["solNumber"] = key
                            let jsonData = try! JSONSerialization.data(withJSONObject: solJson)
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .iso8601
                            let solObject = try! decoder.decode(SolClass.self, from: jsonData)
                            solList.append(solObject)
                        }
                    }
                    
                } catch let error as NSError {
                    print("Failed to load: \(error)")
                }
            }
            onCompletion(solList.sorted(by: { ($0.firstUTC.compare($1.firstUTC) == .orderedDescending
                )}))
        }.resume()
    }
}


