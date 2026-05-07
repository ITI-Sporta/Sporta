//
//  SportResponse.swift
//  Sporta
//
//  Created by Hossam on 05/05/2026.
//

import Foundation


// MARK: - Base Response Wrapper

struct AllSportsResponse<T: Codable>: Codable {
    let result: T?
}


enum AllSportsError: Error, LocalizedError {
    case noData
    case apiError(String)
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .noData: return "No data returned from server."
        case .apiError(let msg): return msg
        case .decodingFailed(let e): return "Decoding error: \(e.localizedDescription)"
        }
    }
}


// api error response
struct APIErrorBody: Decodable {
    let result: [APIErrorMessage]?
    var firstMessage: String? { result?.first?.msg }
}

struct APIErrorMessage: Decodable {
    let msg: String?
}
