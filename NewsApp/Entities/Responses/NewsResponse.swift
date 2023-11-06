//
//  NewsResponse.swift
//  NewsApp
//
//  Created by AungKyawPhyoe on 06/11/2023.
//

import Foundation

// MARK: - NewsResponse
struct NewsResponse: Decodable, Equatable {
    let articles: [Article]
    let totalResults: Int?
}

// MARK: - Article
struct Article: Decodable, Equatable {
    let source: SourceResponse?
    let title: String?
    let description: String?
    let author: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

extension Article {
    static func == (lhs: Article, rhs: Article) -> Bool {
      return lhs.title == rhs.title && lhs.description == rhs.description
    }
}
