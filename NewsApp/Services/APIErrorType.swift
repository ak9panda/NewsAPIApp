//
//  APIErrorType.swift
//  NewsApp
//
//  Created by AungKyawPhyoe on 06/11/2023.
//

import Foundation

enum NetworkError: Error, Equatable {
    /// Unknown error occurred.
    case unknown
    /// Url is invalid error.
    case badURL
    /// Address entered is invalid error.
    case invalidLocation
    /// Status code 500
    case internalServerError
    /// Timeout error.
    case timeout
    /// No Internet connection.
    case noInternetConnectivity
}

extension NetworkError: LocalizedError {
    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Something went wrong"
        case .badURL:
            return "Unauthorised reqest"
        case .invalidLocation:
            return "Invalid Location provided"
        case .internalServerError:
            return "Internal Server Error"
        case .timeout:
            return "Request timeout"
        case .noInternetConnectivity:
            return "The Internet connection appears to be offline."
        }
    }
}
final class APIError: Error {
    let type: NetworkError
    let message: String
    
    init(with type: NetworkError) {
        self.type = type
        self.message = type.localizedDescription
    }
}
