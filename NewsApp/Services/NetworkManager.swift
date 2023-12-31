//
//  NetworkManager.swift
//  NewsApp
//
//  Created by AungKyawPhyoe on 06/11/2023.
//

import Foundation
import RxSwift
import Moya
import RxCocoa

protocol FetchApiServices {
    func fetchHeadline(withCategory category: String) -> Single<NewsResponse?>
    func fetchHeadlineWithSource(sourceId: String) -> Single<NewsResponse?>
    func fetchNewsSources() -> Single<SourceListResponse?>
}

final class NetworkManager: FetchApiServices {
    
    private let provider = MoyaProvider<NetworkService>(plugins: [NetworkLoggerPlugin()])
    
    func request<T: Codable>(networkService: NetworkService) -> Single<T?> {
        if !Reachability.isConnectedToNetwork() {
            return Single.error(APIError(with: .noInternetConnectivity))
        }
        
        return provider
            .rx.request(networkService)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1)))
            .catch { error -> PrimitiveSequence<SingleTrait, Response> in
                return Single.error(APIError(with: .internalServerError))
            }.flatMap {json -> Single<T?> in
                if json.statusCode >= 200 && json.statusCode <= 300 {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let response = try? decoder.decode(T.self, from: json.data) {
                        return Single.just(response)
                    }
                } else {
                    let error = APIError(with: .unknown)
                    return Single.error(error)
                }
                let error = APIError(with: .unknown)
                return Single.error(error)
            }
    }
}

extension NetworkManager {
    func fetchHeadline(withCategory category: String) -> Single<NewsResponse?> {
        return request(networkService: .topHeadlines(category: category))
    }
    
    func fetchHeadlineWithSource(sourceId: String) -> Single<NewsResponse?> {
        return request(networkService: .topHeadlinesWithSource(sourceId: sourceId))
    }
    
    func fetchNewsSources() -> Single<SourceListResponse?> {
        return request(networkService: .getSources)
    }
}
