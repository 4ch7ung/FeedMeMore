//
//  FeedAPIFactory.swift
//  Feed Me More
//
//  Created by macbook on 14.05.2018.
//  Copyright © 2018 4ch7ung. All rights reserved.
//

import Foundation

protocol FeedAPIFactory {
    func createAPI() -> FeedAPI
}

class LentaRuFeedAPIFactory: FeedAPIFactory {
    func createAPI() -> FeedAPI {
        let parser = StandardRssParser()
        return LentaRuFeedAPI(parser: parser)
    }
}
