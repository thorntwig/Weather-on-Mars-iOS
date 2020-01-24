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
    
    func fetchSolList(router: Router, onCompletion: @escaping ([Sol]) ->()) {
        var solList = [Sol]()
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters
        
        guard let url = components.url else { return }
        URLSession.shared.dataTask(with: url) { data, reponse, error in
            if let data = data {
                solList = APIResponseMapper.dataMapper(from: data)
            }
            onCompletion(solList)
        }.resume()
    }
}


