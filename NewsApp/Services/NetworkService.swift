//
//  NetworkService.swift
//  NewsApp
//
//  Created by AungKyawPhyoe on 06/11/2023.
//

import Foundation
import Moya

enum NetworkService {
    case topHeadlines(category: String)
    case getSources
}

extension NetworkService: TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://newsapi.org")!
    }
    
    public var path: String {
        switch self {
        case .topHeadlines: return "/v2/top-headlines"
        case .getSources: return "/v2/sources"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        switch self {
        case .topHeadlines(category: let category):
            return .requestParameters(parameters: ["country": "us", "apiKey": "d043ec92bac0478f88e861eb3ff94437", "category": category], encoding: URLEncoding.default)
        case .getSources:
            return .requestParameters(parameters: ["apiKey": "d043ec92bac0478f88e861eb3ff94437"], encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        let parameters = ["X-Mobile-App": "ios", "Content-Type": "application/json"]
        return parameters
    }
}
