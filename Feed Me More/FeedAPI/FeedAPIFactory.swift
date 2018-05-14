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
        return StandardFeedAPI(name: "Lenta.ru", feedUrl: "https://lenta.ru/rss/news", parser: parser)
    }
}

class GazetaRuFeedAPIFactory: FeedAPIFactory {
    func createAPI() -> FeedAPI {
        let parser = StandardRssParser()
        return StandardFeedAPI(name: "Gazeta.ru", feedUrl: "https://www.gazeta.ru/export/rss/lenta.xml", parser: parser)
    }
}
