import Foundation

enum Router {
    case getInsightSols
    
    var scheme: String {
        switch self {
        case .getInsightSols:
            return "https"
        }
    }
    
    var host: String {
        switch self {
        case .getInsightSols:
            return "api.nasa.gov"
        }
    }
    
    var path: String {
        switch self {
        case .getInsightSols:
            return "/insight_weather/"
        }
    }
    
    var parameters: [URLQueryItem] {
        let apiKey = "pqYoj1vWsXGV8UwlhRbSCeReZEDytTeep3rkghkH"
        switch self {
        case .getInsightSols:
            return [URLQueryItem(name: "api_key", value: apiKey),
                    URLQueryItem(name: "feedtype", value: "json"),
                    URLQueryItem(name: "ver", value: "1.0")]
        }
    }
    var method: String {
        switch self {
        case .getInsightSols:
            return "GET"
        }
    }
}
