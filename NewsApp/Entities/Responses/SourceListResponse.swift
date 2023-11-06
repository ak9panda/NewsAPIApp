//
//  SourceListResponse.swift
//  NewsApp
//
//  Created by AungKyawPhyoe on 06/11/2023.
//

import Foundation

struct SourceListResponse: Decodable, Equatable {
    let sources: [SourceResponse]?
    let status: String?
}

extension SourceListResponse {
    static func == (lhs: SourceListResponse, rhs: SourceListResponse) -> Bool {
       return lhs.status == rhs.status && lhs.sources?.count == rhs.sources?.count
    }
}

// MARK: - SourceResponse
struct SourceResponse: Codable, Equatable {
    let id: String?
    let name: String?
    let description: String?
    let url: String?
    let category: String?
    let language: String?
    let country: String?
}
