//
//  NetworkError.swift
//  IosNetworkExample
//
//  Created by kanagasabapathy on 01/01/24.
//

import Foundation

public enum NetworkError: Error {
    case decode
    case generic
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown

    public var customMessage: String {
        switch self {
        case .decode:
            return "Decode Error"
        case .unauthorized:
            return "Unauthorized URL"
        case .generic:
            return "Sorry, try again later"
        default:
            return "Unknown Error"
        }
    }
}
