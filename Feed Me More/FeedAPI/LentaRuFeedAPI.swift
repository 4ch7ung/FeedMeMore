//
//  LentaRuFeedAPI.swift
//  Feed Me More
//
//  Created by macbook on 14.05.2018.
//  Copyright © 2018 4ch7ung. All rights reserved.
//

import Foundation
import Alamofire

class LentaRuFeedAPI: FeedAPI {
    private let feedUrlString: String
    private let apiQueue: DispatchQueue
    private let parser: RssParser
    
    init(parser: RssParser) {
        self.feedUrlString = "https://lenta.ru/rss/news"
        self.apiQueue = DispatchQueue(label: "lenta-ru-feed-api")
        self.parser = parser
    }
    
    func requestFeed(success: @escaping (FeedResult) -> Void, failure: @escaping (Error) -> Void) {
        Alamofire.request(feedUrlString)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/rss+xml"])
            .responseData(queue: self.apiQueue) { response in
                switch response.result {
                case .success(let data):
                    let items = self.parser.parse(data: data)
                    let apiResult = FeedResult(items: items)
                    DispatchQueue.main.async {
                        success(apiResult)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        failure(error)
                    }
                }
        }
    }
}
