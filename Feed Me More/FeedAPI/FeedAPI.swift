//
//  FeedAPI.swift
//  Feed Me More
//
//  Created by macbook on 14.05.2018.
//  Copyright © 2018 4ch7ung. All rights reserved.
//

import Foundation

struct FeedResult {
    var items: [Item] = []
}

protocol FeedAPI {
    var name: String { get }
    
    func requestFeed(success: @escaping (FeedResult) -> Void, failure: @escaping (Error) -> Void)
}

enum FeedAPIError: LocalizedError {
    case requestFailed
    case dataParsingFailed
    case httpError(Int)
    
    var errorDescription: String? {
        switch self {
        case .requestFailed:
            return "Request has failed to complete"
        case .dataParsingFailed:
            return "Failed to parse response data"
        case .httpError(let code):
            return "Failed to get data. HTTP \(code)"
        }
    }
}
